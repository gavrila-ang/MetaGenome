# MetaGenome
Genome assembly workflow for metagenomic PacBio CLRs

This repository provides a comprehensive guide to performing a genome assembly using metagnomic PacBio CLRs.
It contains a Jupyter notebook with step-by-step instructions for each assembly step, along with [BUSCO](https://busco.ezlab.org/)
(Benchmarking Universal Single-Copy Orthologs) and [QUAST](http://bioinf.spbau.ru/quast) (Quality Assessment Tool for Genome Assemblies)
results for each step of the assembly process. The steps include the initial assembly, purging, scaffolding, filtering, and quality control steps. 

The repository aims to provide a transparent and reproducible method for genome assembly.

## Prerequisites
- Python
- Jupyter Notebook
- Conda
- Required libraries installed (listed in requirements.sh file)

## Download
1. Download the genomic data by emailing Arun Sethuraman: asethuraman@sdsu.edu
   The workflow can be modified to be used on your own genomic reads.
   
3. Download the assembly_workflow.ipynb

    ```
    git clone https://github.com/gavrila-ang/MetaGenome.git
    ```

4. Navigate to the cloned repository:

    ```
    cd MetaGenome
    ```

5. Install the necessary Python packages list in requirements.txt:

    ```
    chmod +x requirements.sh
    ./requirements.sh
    ```

## Usage

1. Launch Jupyter Notebook from the command line:

    ```
    jupyter-notebook
    ```

2. Open `assembly_workflow.ipynb` from the Jupyter notebook interface in your browser.

3. Execute the commands in each cell of the Jupyter notebook from your command line interface to follow the genome assembly process.
   Remember to replace the placeholder data, if you are assembling your own genome.

## File Structure

- `assembly_workflow.ipynb` - Jupyter Notebook with step-by-step instructions for genome assembly.

- `/busco_results/` - Directory containing BUSCO results for each step of the assembly process.

- `/quast_results/` - Directory containing QUAST results for each step of the assembly process.

## Results Interpretation

### BUSCO
BUSCO results provide information about the completeness and correctness of the genome assembly by comparing it with a set of universally single-copy orthologs.

### QUAST
QUAST results provide several metrics including N50, L50, total length, etc. for evaluating the contiguity of the assembly.

## Authors

* Gavrila Ang - https://github.com/gavrila-ang
* Arun Sethuraman - https://github.com/arunsethuraman

## License

This project is licensed under the MIT License - see the LICENSE file for details
