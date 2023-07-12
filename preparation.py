#!/usr/bin/env python


import subprocess
import os

# List which tools they need
tools = ["canu", "purge_dups", "minimap2", "ragtag", "quast", "busco", "augustus", "AUGUSTUS-helpers"]

print("This assembly pipeline requires the following tools:")
print(*tools, sep='\n')



# Tell them they need a genome for scaffolding
print("You will also need a reference genome, or a genome of a closely related species for the scaffolding step")



# Export the absolute filepaths and required user input data of the tools
with open("script.sh", "w") as script_file:
    script_file.write("#!/bin/bash\n\n")
    for tool in tools:
        file_path = os.path.abspath(input(f"Enter the relative file path for {tool}: "))
        script_file.write(f"export PATH=$PATH:{file_path}\n")



    # Export the filepath of the long reads data
    pacbio_path = os.path.abspath(input("Enter the relative file path for your PacBio data: "))
    script_file.write(f"pacbio_path={pacbio_path}\n")



    # Export the absolute filepaths of the reference genome
    refgen_path = os.path.abspath(input("Enter the relative file path for your reference genome: "))
    script_file.write(f"refgen_path={refgen_path}\n")
    


    # Retrieve the estimated genome size for genome_assembly
    est_size = input(f"Enter the estimated genome size: ")
    script_file.write(f"est_size={est_size}\n")


    # Retrieve the lineage dataset to be used for BUSCO analysis
    lineage_dataset = input(f"Enter the lineage dataset to be used for BUSCO analysis: ")
    script_file.write(f"lineage_dataset={lineage_dataset}\n")


    # Retrieve the trained species model to be used during Augustus annotation
    trained_model = input(f"Enter the trained species model to be used for Augustus annotation: ")
    script_file.write(f"trained_model={trained_model}\n")



# Specify the directory where all script files are located
directory = '.' 

    # Make all script files executable
for filename in os.listdir(directory):
    if filename.endswith('.sh'):
        filepath = os.path.join(directory, filename)
        os.chmod(filepath, 0o755)

print("All scripts are now executable.")
    
