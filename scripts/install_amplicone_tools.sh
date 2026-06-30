#!/bin/bash

#SBATCH --job-name=installAmpliconeTools
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16G
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_amplicone/bin:$PATH"
set -e

# BLAST
conda install -c bioconda blast -y

# RepeatMasker
conda install -c bioconda repeatmasker -y

# Tandem Repeat Finder
conda install -c bioconda trf -y

# GenMap
conda install -c bioconda genmap -y
