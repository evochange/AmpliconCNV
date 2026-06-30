#!/bin/bash

#SBATCH --job-name=runCNVnatorSample17
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_cnvnator/bin:$PATH"

# NAMING
sample="Sample_17"
BIN_SIZE=3000

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"

# mm39
out_mm39="$base/results/cnvnator/mm39"
bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"
ref_mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
root_mm39="$out_mm39/${sample}_mm39.root"
chroms_mm39="$base/data/references/mm39/chroms_links/"
calls_mm39="$out_mm39/${sample}_mm39_bin${BIN_SIZE}_calls.txt"

# T2T
out_t2t="$base/results/cnvnator/t2t"
bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"
ref_t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
root_t2t="$out_t2t/${sample}_T2T.root"
chroms_t2t="$base/data/references/t2t/clean_chroms/"
calls_t2t="$out_t2t/${sample}_T2T_bin${BIN_SIZE}_calls.txt"

# DIRS CREATION
mkdir -p "$out_mm39" "$out_t2t"

# DELETING OLD FILES
rm -f "$calls_mm39" "$calls_t2t"

# REMAKING TREE
# Uncomment in case BAM data has changed
# rm -f "$root_mm39" "$root_t2t"

# TREE ROOT CREATION
# mm39
cnvnator -root "$root_mm39" -tree "$bam_mm39"
cnvnator -root "$root_mm39" -his $BIN_SIZE -d "$chroms_mm39"
cnvnator -root "$root_mm39" -stat $BIN_SIZE
# T2T
cnvnator -root "$root_t2t" -tree "$bam_t2t"
cnvnator -root "$root_t2t" -his $BIN_SIZE -d "$chroms_t2t"
cnvnator -root "$root_t2t" -stat $BIN_SIZE

# CNV CALLING
# mm39
cnvnator -root "$root_mm39" -partition $BIN_SIZE
cnvnator -root "$root_mm39" -call $BIN_SIZE > $calls_mm39
# T2T
cnvnator -root "$root_t2t" -partition $BIN_SIZE
cnvnator -root "$root_t2t" -call $BIN_SIZE > $calls_t2t
