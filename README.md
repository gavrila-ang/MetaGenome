# MetaGenome

MetaGenome is a de novo genome assembly workflow that automates the assembly of metagenomic data into an unphased haploid genome. It simplifies the execution and customization of the assembly workflow, providing a user-friendly approach to complex computational tasks. The workflow is designed to address the high-memory requirements of genome assembly, allowing the `assembly_workflow.sh` and a parameter script generated from user input to be submitted to a High-Performance Computing (HPC) cluster.

## Prerequisites

This workflow requires a reference genome of a closely related species for scaffolding. Additionally, the project uses a number of software tools and libraries. Before running the assembly workflow, make sure to install all dependencies listed in the `requirements.txt` file. Each tool in the file includes a link to the download page.

## Download

To clone the MetaGenome repository, run the following command in your terminal:

```bash
https://github.com/gavrila-ang/MetaGenome.git
```

*(Please replace 'username' with the actual username of the repository owner.)*

## Usage

The workflow is initiated by capturing user inputs via `user_prompt.sh`, which subsequently generates an executable parameter script. This parameter script along with the `assembly_workflow.sh` are designed to be submitted to an HPC cluster. 

1. Make `user_prompt.sh` and `assembly_workflow.sh` scripts executable. In your terminal, use the following commands:

```bash
chmod +x user_prompt.sh
chmod +x assembly_workflow.sh
```

2. Configure the workflow parameters through user prompts:

```bash
./user_prompt.sh
```
This will generate a parameters script based on your input.

3. Run the assembly workflow, either locally (given sufficient resources) or on an HPC cluster:

```bash
./assembly_workflow.sh
```

## File Structure

The project contains the following key files:

- `assembly_workflow.sh`: This script automates the assembly of metagenomic data into an unphased haploid genome.
- `user_prompt.sh`: This script obtains the necessary parameters for the `assembly_workflow.sh` through user input and generates an executable parameters script.
- `requirements.txt`: This file lists the necessary tools and the websites where they can be downloaded.

## Results Interpretation (QUAST and BUSCO)

Results of the assembly process can be interpreted using the 3C criterion:

1. **Contiguity** - QUAST generates the N50 metric, which measures the length such that 50% of the total sequence length is contained in contigs or scaffolds of this length or longer. Higher N50 values generally indicate better contiguity. A contig N50 value of 1Mb is ideal for third generation sequencing. 

2. **Completeness** - BUSCO assesses the completeness of the assembly by comparing it to a set of universal single-copy orthologs. A high percentage (ideally > 95%) of these "Benchmarking Universal Single-Copy Orthologs" in the assembly indicates high completeness. 

3. **Correctness** - BUSCO duplication measures the number of times universal single-copy orthologs appear more than once in the assembly. A low percentage of duplications (ideally < 5%) generally indicates a more correct assembly.

For a detailed interpretation guide, please refer to the official documentation of these tools.

## Authors

The MetaGenome repository is maintained by the following authors:

- [Gavrila Ang](https://github.com/gavrila-ang)
- [Arun Sethuraman](https://github.com/arunsethuraman)

Please feel free to contact for any questions or suggestions.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

