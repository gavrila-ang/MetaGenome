#!/bin/bash

echo "Enter file path of concatenated PacBio CLRs: "
read pacbio_filepath
echo "pacbio_all=${pacbio_filepath}" > user_input.sh   


echo "Enter the file path of reference genome to be used for scaffolding: " 
read ref_filepath
echo "ref=${ref_filepath}" >> user_input.sh


echo "Enter the estimated size of the genome assembly: "
read genome_size
echo "genome_size=${genome_size}" >> user_input.sh


echo "Enter the BUSCO lineage dataset to be used for BUSCO analysis: "
read busco_lineage
echo "busco_lineage=${busco_lineage}" >> user_input.sh

echo "Enter the number of threads (cores) to be used for the assembly tools: "
read threads
echo "threads=${threads}" >> user_input.sh


# Make the user_input.sh file executable
chmod +x user_input.sh


echo "Remember to set the path containing user_input.sh in your batch script"

