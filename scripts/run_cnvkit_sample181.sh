#!/bin/bash

#SBATCH --job-name=runCNVkitSample181
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate env_cnvkit

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
mapped_t2t="$base/data/mapped/t2t"
mapped_mm39="$base/data/mapped/mm39"
out="$base/results/cnvkit"
sample="Sample_181"

# CREATING DIRS
mkdir -p "$out/mm39"
mkdir -p "$out/t2t"

# mm39
cnvkit.py batch "$mapped_mm39/${sample}_mm39_markdup.bam" \
    -n \
    -y \
    --fasta "$mm39" \
    --method wgs \
    --output-dir "$out/mm39" \
    -p 16 \
    --scatter --diagram

# T2T
cnvkit.py batch "$mapped_t2t/${sample}_T2T_markdup.bam" \
    -n \
    -y \
    --fasta "$t2t" \
    --method wgs \
    --output-dir "$out/t2t" \
    -p 16 \
    --scatter --diagram
