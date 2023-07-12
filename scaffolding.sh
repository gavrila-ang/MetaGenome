#!/bin/bash

# Step 3: Scaffolding

echo "Step 3: Scaffolding has started"

# Execute script containing filepaths and variables
./script.sh

# Step 3.1: Run RagTag scaffolding using the harmonia axyridis genome as a reference
ragtag.py scaffold refgen_path best_assembly.fasta -o ragtag_scaffold_output

# Step 3.2: Copy the assembly of interest into the main directory
cp -f ragtag_scaffold_output/ragtag.scaffold.fasta best_assembly.fasta 

echo "Step 3: Scaffolding has completed" 
