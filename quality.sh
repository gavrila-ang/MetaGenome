#!/bin/bash

# Step 4: Quality Assessment

echo "Step 4: Quality Assessment has started"

# Execute script containing filepaths and variables
./script.sh


# Step 4.1: Genome Completeness Assessment
busco -i best_assembly.fasta -l $lineage_dataset -o busco_output -m genome -c 48

# Extract the total BUSCO completeness score
completeness_score=$(grep -o 'C:[0-9]*\.[0-9]*%' busco_output/short*.txt | grep -o '[0-9]*\.[0-9]*')


# Step 4.2: Genome Contiguity Assessment
quast best_assembly.fasta -o quast_output --split-scaffolds

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
fi


echo
echo "Step 4: Quality Assessment has completed" 
