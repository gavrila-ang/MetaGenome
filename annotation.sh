#!/bin/bash

# Step 5.1: Assembly

echo "Step 5: Annotation has started"

# Execute script containing filepaths and variables
./script.sh


# Run augustus
augustus --genemodel=complete --gff3=on --protein=on --codingseq=on --cds=on --species=$trained_model best_assembly.fasta > hcon.gff &&


# Extract coding and protein sequences from gff 
nohup get-fasta.sh -c cds_output.fasta -p protein_output.fasta hcon.gff

echo "Step 5: Annotation has completed"
