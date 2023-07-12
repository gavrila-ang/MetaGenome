#!/bin/bash

# Create an assembly directory
mkdir genome_assembly

# Move inside that assembly directory
cd genome_assembly 

# Export the tool file paths and variables
source script.sh

############### Step 1: Assembly ###############

echo "Step 1: Assembly starting" 

# Step 1: Assembly with Canu
canu \
 -p canu_assembly -d canu_output \
 genomeSize=$genome_size \
 -pacbio $pacbio_reads &&

echo "Step 1: Assembly complete" 


############### Step 2: Purging ###############

echo "Step 2: Purging starting" 

# Step 2.1: Create an output folder for purge_dup generated files
mkdir purgedup_output
cd purgedup_output
echo "Step 2.1 complete" &&

# Step 2.2: Run minimap2 to align pacbio data agains the assembly and generate paf files, 
minimap2 -t48 -xmap-pb ../canu_output/canu_assembly.contigs.fasta \
$pacbio_reads | gzip -c - > pb1.paf.gz &&
echo "Step 2.2 complete" &&

# Step 2.3: Then run the pbcstat, calcuts functions on it to calculate read depth histogram and base-level read depth
pbcstat *.paf.gz &&
calcuts PB.stat > cutoffs 2> calcults.log && 
echo "Step 2.3 complete" &&

# Step 2.4: Then split the assembly file, do a self alignment
split_fa ../canu_output/canu_assembly.contigs.fasta > masked_genome.split &&
echo "Step 2.4 complete" &&

# Step 2.5: Run minimap2 for self alignment
minimap2 -t48 -xasm5 -DP masked_genome.split masked_genome.split | gzip -c - > masked_genome.split.self.paf.gz &&
echo "Step 2.5 complete" &&

# Step 2.6: Purge haplotigs and overlaps
purge_dups -2 -T cutoffs -c PB.base.cov masked_genome.split.self.paf.gz > dups.bed 2> purge_dups.log &&
echo "Step 2.6 complete" &&

# Step 2.7: Get purged primary and haplotig sequences from draft assembly
get_seqs -e dups.bed ../canu_output/canu_assembly.contigs.fasta &&
echo "Step 2.7 complete" &&


# Step 2.8: Move out of the purge_dup folder
cd ..

echo "Step 2: Purging complete" 





############### Step 3: Scaffolding ###############

echo "Step 3: Scaffolding starting" 

# Step 3:  Run RagTag scaffolding using the harmonia axyridis genome as a reference
ragtag.py scaffold $reference_genome purge_dup/purged.fa -o ragtag_scaffold_output 


echo "Step 3: Scaffolding complete"





############### Step 4: Quality Assessment ###############

# Step 4.1: Genome Completeness Assessment
busco -i ragtag_scaffold_output/ragtag.scaffold.fasta -l $lineage_dataset -o busco_output -m genome -c 48

# Extract the total BUSCO completeness score
completeness_score=$(grep -o 'C:[0-9]*\.[0-9]*%' busco_output/short*.txt | grep -o '[0-9]*\.[0-9]*')


# Step 4.2: Genome Contiguity Assessment
quast ragtag_scaffold_output/ragtag.scaffold.fasta -o quast_output --split-scaffolds

# Extract the N50 score
contiguity_score=$(grep 'N50' quast_output/report.txt | sed -E 's/N50[[:space:]]+([0-9]+)/\1/')
contiguity_score=$(echo "scale=2; $contiguity_score/1000000" | bc -l)




# Step 4.3: Genome Correctness Asessment

# Extract the duplicate BUSCO score
correctness_score=$(grep -o 'D:[0-9]*\.[0-9]*%' busco_output/short*.txt | grep -o '[0-9]*\.[0-9]*')




# Step 4.4: Quality Assessment Summary
echo "The standard BUSCO complete score is 95 %, the assembly score is $completeness_score %."
echo "The standard N50 score is >1 mb, the assembly score is $contiguity_score mb."
echo "The standard BUSCO duplication score is <5 %, the assembly score is $correctness_score %."

echo

if (( $(echo "$completeness_score < 95" | bc -l) )); then
	echo "Completion criteria has not been met."
fi

if (( $(echo "$contiguity_score < 1" | bc -l) )); then
	echo "Contiguity criteria has not been met."
fi

if (( $(echo "$correctness_score > 5" | bc -l) )); then
	echo "Correctness criteria has not been met."
fi

if (( $(echo "$completeness_score > 95 && $contiguity_score > 1 && $correctness_score < 5" | bc -l) )); then
	echo "The 3C criterion has been met. Proceed to Step 6: Annotation."
else
	echo "Modify assembly tool scripts in bin folder and rerun assembly pipeline."
	exit()
fi


echo
echo "Step 4: Quality Assessment has completed" 





############### Step 5: Annotation ###############

echo "Step 5: Annotation has started"


# Step 5.1: Run augustus
augustus --genemodel=complete --gff3=on --protein=on --codingseq=on --cds=on --species=$trained_model ragtag_scaffold_output/ragtag.scaffold.fasta > hcon.gff &&


# Step 5.2: Extract coding and protein sequences from gff 
get-fasta.sh -c cds_output.fasta -p protein_output.fasta hcon.gff

echo "Step 5: Annotation has completed"




############### Final Assembly Output ###############

cp ragtag_scaffold_output/ragtag.scaffold.fasta final_assembly.fasta








