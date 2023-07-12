#!/bin/bash

# Step 1: Assembly

echo "Step 1: Assembly has started"

# Execute script containing filepaths and variables
./script.sh

# Step 1.1: Assemble the genome
canu \
 -p canu_assembly -d canu_output \
 genomeSize=$est_size \
 -pacbio $pacbio_path &&


# Step 1.2: Copy the assembly of interest into the main directory
cp -f canu_output/canu_assembly.contigs.fasta best_assembly.fasta &&

echo "Step 1: Assembly has completed"
