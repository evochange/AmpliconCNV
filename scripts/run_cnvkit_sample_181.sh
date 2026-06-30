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

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_cnvkit/bin:$PATH"

# VARIABLES
sample="Sample_181"
run="1"
# This line has been commented for the default values on this run
# --target-avg-size "$TARGET_SIZE" \ After WGS
TARGET_SIZE=3000     # 1st run: 1000, 2nd run: 3000, 3rd run: nd

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"

# mm39
out_mm39="$base/results/cnvkit/mm39/run$run"
ref_mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"

# T2T
out_t2t="$base/results/cnvkit/T2T/run$run"
ref_t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"

# DIRS CREATION
mkdir -p "$out_mm39" "$out_t2t"

# mm39
cnvkit.py batch "$bam_mm39" \
    -n \
    -y \
    --fasta "$ref_mm39" \
    --method wgs \
    --output-dir "$out_mm39" \
    -p 16 \
    --scatter --diagram

# T2T
cnvkit.py batch "$bam_t2t" \
    -n \
    -y \
    --fasta "$ref_t2t" \
    --method wgs \
    --output-dir "$out_t2t" \
    -p 16 \
    --scatter --diagram
