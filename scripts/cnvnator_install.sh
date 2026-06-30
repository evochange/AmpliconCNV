#!/bin/bash

#SBATCH --job-name=CNVnatorInstall
#SBATCH --time=30:00:00
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda config --set channel_priority strict

conda create -n env_cnvnator -c conda-forge -c bioconda python=3.9 htslib=1.14 cnvnator=0.4.1 root_base=6.24.6 htslib=1.14 -y
