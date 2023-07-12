#!/bin/bash


############### Preparation: Export the absolute filepaths of assembly tools ###############

echo "Preparation starting" 

# Preparation Step 1: Export the absolute file paths of assembly tools to an executable script 

echo "#!/bin/bash" > script.sh

	# Prompt for absolute paths of tool directories
read -p "Enter the absolute path for 'canu': " canu_path
read -p "Enter the absolute path for 'purge_dups': " purge_dups_path
read -p "Enter the absolute path for 'minimap2': " minimap2_path
read -p "Enter the absolute path for 'ragtag': " ragtag_path
read -p "Enter the absolute path for 'quast': " quast_path
read -p "Enter the absolute path for 'busco': " busco_path
read -p "Enter the absolute path for 'augustus': " augustus_path
read -p "Enter the absolute path for 'AUGUSTUS-helpers': " augustus_helpers_path

	# Export the tool directories and append them to script.sh
echo "export PATH=$PATH:\"$canu_path\"" >> script.sh
echo "export PATH=$PATH:\"$purge_dups_path\"" >> script.sh
echo "export PATH=$PATH:\"$minimap2_path\"" >> script.sh
echo "export PATH=$PATH:\"$ragtag_path\"" >> script.sh
echo "export PATH=$PATH:\"$quast_path\"" >> script.sh
echo "export PATH=$PATH:\"$busco_path\"" >> script.sh
echo "export PATH=$PATH:\"$augustus_path\"" >> script.sh
echo "export PATH=$PATH:\"$augustus_helpers_path\"" >> script.sh

	# Prompt for absolute file paths of genomic data
read -p "Enter the absolute file paths of the reference genome: " reference_genome
read -p "Enter the absolute file paths of the PacBio reads: " pacbio_reads

	# Export the genomic data file paths and append them to script.sh
echo "export reference_genome=\"$reference_genome\"" >> script.sh
echo "export pacbio_reads=\"$pacbio_reads\"" >> script.sh 

	# Prompt for tools variables
read -p "Enter a genome size estimate: " genome_size
read -p "Enter a lineage dataset to be used during BUSCO analysis: " lineage_dataset
read -p "Enter the trained species model to be used for Augustus annotation: " trained_model

	# Export the tool variables and append them to script.sh
echo "export genome_size=\"$genome_size\"" >> script.sh
echo "export lineage_dataset=\"$lineage_dataset\"" >> script.sh
echo "export trained_model=\"$trained_model\"" >> script.sh

	# Make the script.sh executable
chmod +x script.sh 

 
echo "Preparation complete" 



