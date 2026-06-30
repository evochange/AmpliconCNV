#!/bin/bash

#SBATCH --job-name=ERR9880211download
#SBATCH --time=12:00:00
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

base="/users1/cpca070092024/fmarinha"
ref_path="$base/projeto_estagio/data/test_data"
embl="ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR988/001/ERR9880211"

curl -o "$ref_path"/ERR9880211_1.fastq.gz "$embl"/ERR9880211_1.fastq.gz
curl -o "$ref_path"/ERR9880211_2.fastq.gz "$embl"/ERR9880211_2.fastq.gz
