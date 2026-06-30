#!/bin/bash

#SBATCH --job-name=evalCNVnator
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=32G
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_cnvnator/bin:$PATH"

# NAMING
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")
run="4"
bin_sizes=(6000, 7000)

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
out_dir="$base/results/cnvnator/eval"

# PATHS CHROMS
chroms_mm39="$base/data/references/mm39/chroms_links/"
chroms_t2t="$base/data/references/t2t/clean_chroms/"

# DIR CREATION
mkdir -p "$base/results/cnvnator/eval"

for sample in "${samples[@]}"; do
    bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"
    root_mm39="$out_dir/${sample}_mm39_EVAL${run}.root"

    bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"
    root_t2t="$out_dir/${sample}_T2T_EVAL${run}.root"

    rm -f "$root_mm39" "$root_t2t"

    cnvnator -root "$root_mm39" -tree "$bam_mm39"
    cnvnator -root "$root_t2t" -tree "$bam_t2t"

    for TEST_BIN in "${bin_sizes[@]}"; do
	      # mm39
		    cnvnator -root "$root_mm39" -his $TEST_BIN -d "$chroms_mm39"
        cnvnator -root "$root_mm39" -stat $TEST_BIN
        cnvnator -root "$root_mm39" -eval $TEST_BIN
        # T2T
        cnvnator -root "$root_t2t" -his $TEST_BIN -d "$chroms_t2t"
        cnvnator -root "$root_t2t" -stat $TEST_BIN
        cnvnator -root "$root_t2t" -eval $TEST_BIN
    done
done
