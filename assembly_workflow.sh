#!/bin/bash

# Source the file containing user input variables
source user_input.sh





# Step 1: Assembly with Canu
canu \
 -p canu_assembly -d canu_output \
 genomeSize=$genome_size \
 -pacbio $pacbio_all &&





# Step 2.1: Create an output folder for purge_dup generated files
mkdir purgedup_output
cd purgedup_output


# Step 2.2: Run minimap2 to align pacbio data agains the assembly and generate paf files, 
minimap2 -t $threads -xmap-pb ../canu_output/canu_assembly.fasta \
$pacbio_all | gzip -c - > pb1.paf.gz &&


# Step 2.3: Run pbcstat, calcuts functions on it to calculate read depth histogram and base-level read depth
pbcstat *.paf.gz &&
calcuts PB.stat > cutoffs 2> calcults.log && 


# Step 2.4: Then split the assembly file, do a self alignment
split_fa ../canu_output/canu_assembly.fasta > masked_genome.split &&


# Step 2.5: Run minimap2 for self alignment
minimap2 -t $threads -xasm5 -DP masked_genome.split masked_genome.split | gzip -c - > masked_genome.split.self.paf.gz &&


# Step 2.6: Purge haplotigs and overlaps
purge_dups -2 -T cutoffs -c PB.base.cov masked_genome.split.self.paf.gz > dups.bed 2> purge_dups.log &&


# Step 2.7: Get purged primary and haplotig sequences from draft assembly
get_seqs -e dups.bed ../canu_output/canu_assembly.fasta &&


# Step 2.8: Move out of the purgedup folder
cd ..





# Step 3.1: Create an output folder for ragtag generated files
mkdir ragtag_scaffold_output


# Step 3.2: Run RagTag scaffolding using the reference genome
ragtag.py scaffold $ref purgedup_output/purged.fa -o ragtag_scaffold_output &&


# Step 3.3: Move out of the ragtag folder
cd ..





# Step 4.1 Create an output folder for filtlong generated files
mkdir filtlong_output


# Step 4.2: Remove assembly artifacts by removing shorter contigs that did not map well to the reference
filtlong --min_length 50000 ragtag_scaffold_output/ragtag.scaffold.fasta > filtlong_output/assembly.fasta &&





# Step 5.1: BUSCO Check
busco -i filtlong_output/assembly.fasta -l $busco_lineage -o busco_output -m genome -c $threads &&


# Step 5.2: QUAST Check
quast filtlong_output/assembly.fasta -o quast_output --split-scaffolds


# Step 5.3: Extract completeness, contiguity, and correctness score


echo "To fulfill the 3C criterion, we established minimum benchmarks which included a complete BUSCO score of 95% or less, an N50 exceeding 1Mb, and a BUSCO duplication score below 3%."


completeness_score=$(grep "C:" busco_output/short_summary.*.txt | cut -d '%' -f1 | cut -d ':' -f2)
echo "The completeness score of the final assembly is ${completeness_score} %"
if (( $(echo "$completeness_score >= 95" | bc -l) )); then
    echo "The completeness criterion was reached"
else
    echo "The completeness criterion was not reached. Rerun assembly workflow using modified tool parameters"
fi


correctness_score=$(grep "C:" busco_output/short_summary.*.txt | cut -d '%' -f3 | cut -d ':' -f2)
echo "The correctness score of the final assembly is ${correctness_score} %"
if [ $contiguity_score -ge 1000000 ]; then
    echo "The contiguity criterion was reached"
else
    echo "The contiguity criterion was not reached. Rerun assembly workflow using modified tool parameters"
fi


contiguity_score=$(grep "N50" quast_output/report.txt | tr -s ' ' | cut -d ' ' -f3)
echo "The contiguity score of the final assembly is N50 ${contiguity_score} bases"
if [ $correctness_score -le 3 ]; then
    echo "The correctness criterion was reached"
else
    echo "The correctness criterion was not reached. Consider rerunning the assembly workflow using modified tool parameters"
fi





echo "The assembly workflow has completed. Exiting."





