#!/usr/bin/env python


import subprocess
import os
    

# Step 1: Assembly
    # Run the script 
assembly_run = subprocess.run(["./assemble.sh"]
print("The exit code was: %d" % assembly_run.returncode)        



# Step 2: Purging                            
    # Run the script
purge_run = subprocess.run(["./purge.sh"]
print("The exit code was: %d" % purge_run.returncode)  



# Step 3: Scaffolding
    # Run the script
scaffold_run = subprocess.run(["./scaffold.sh"]
print("The exit code was: %d" % scaffold_run.returncode)  



# Step 4: Quality Assessment
    # Run the script                              
quality_run = subprocess.run(["./quality.sh"]
print("The exit code was: %d" % quality_run.returncode)
                             


# Step 5: Annotation
    # Run the script
annotation_run = subprocess.run(["./annotation.sh"]
print("The exit code was: %d" % annotation_run.returncode)



