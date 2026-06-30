#!/bin/bash

#SBATCH --job-name=ERR9880211mapping1
#SBATCH --time=18:00:00
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/mapping_mouse/scripts/logs/slurm-%j.out

conda activate mouse_mapping

base="/users1/cpca070092024/fmarinha"
ref_path="$base/projeto_estagio/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
raw_1="$base/projeto_estagio/data/test_data/ERR9880211_1.fastq.gz"
raw_2="$base/projeto_estagio/data/test_data/ERR9880211_2.fastq.gz"
output="$base/projeto_estagio/data/mapped/mm39/BALB_cJ.bam"

~/minimap2-2.31_x64-linux/minimap2 -ax sr -t 12 "$ref_path" "$raw_1" "$raw_2" | samtools sort -@ 4 -o "$output"

samtools index "$output"
