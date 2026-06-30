# AmpliconCNV
A collection of Bash scripts used for mapping, post-processing and running CNV detection tools (CNVnator, Control-FREEC, CNVkit, AmpliCoNE) on M. Musculus short-read sequencing data via Slurm, as well as some of the results obtained.

## Requirements
To be able to use the scripts, you will need to have:
- conda 4.10.3

## Tool environment installation
For each tool, you will need to setup a specific environment. It is reccomended, if possible, to use the scripts provided in a server, due to installation time.

### CNVnator

```
conda create -n env_cnvnator -c conda-forge -c bioconda python=3.9 htslib=1.14 cnvnator=0.4.1 root_base=6.24.6 htslib=1.14 -y
```

### Control-FREEC

```
conda create -n env_freec -c conda-forge -c bioconda control-freec
```

### CNVkit

```
conda create -n env_cnvkit -c bioconda -c conda-forge cnvkit
```

### AmpliCoNE
AmpliCoNE must be installed following its repository's instructions.
