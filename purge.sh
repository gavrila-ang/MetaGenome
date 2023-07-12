#!/bin/bash

# Step 2: Purging

echo "Step 2: Purging has started"

# Execute script containing filepaths and variables
./script.sh

# Step 2.1: Create an output folder for purge_dup generated files
mkdir purgedup_output
cd purgedup_output

# Step 2.2: Run minimap2 to align pacbio data agains the assembly and generate paf files 
minimap2 -t48 -xmap-pb ../best_assembly.fasta $pacbio_path | gzip -c - > pb1.paf.gz &&

# Step 2.3: Then run the pbcstat, calcuts functions on it to calculate read depth histogram and base-level read depth
pbcstat *.paf.gz &&
calcuts PB.stat > cutoffs 2> calcults.log &&

# Step 2.4: Then split the assembly file, do a self alignment
split_fa ../best_assembly.fasta > masked_genome.split &&

# Step 2.5: Run minimap2 for self alignment
minimap2 -t48 -xasm5 -DP masked_genome.split masked_genome.split | gzip -c - > masked_genome.split.self.paf.gz &&

# Step 2.6: Purge haplotigs and overlaps
purge_dups -2 -T cutoffs -c PB.base.cov masked_genome.split.self.paf.gz > dups.bed 2> purge_dups.log &&

# Step 2.7: Get purged primary and haplotig sequences from draft assembly
get_seqs -e dups.bed ../best_assembly.fasta &&

# Step 2.8: Copy the assembly of interest into the main directory
cp -f purged.fa ../best_assembly.fasta &&

echo "Step 2: Purging has completed" 

cd ..


