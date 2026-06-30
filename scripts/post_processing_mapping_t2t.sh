#!/bin/bash

#SBATCH --job-name=postProcessingMappingT2T
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate mouse_mapping

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
tmp="$base/tmp/t2t_tmp"
mapped="$base/data/mapped/t2t"
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

for sample in "${samples[@]}"; do
	bam="$mapped/${sample}_T2T_bwamem2.bam"
	out="$mapped/${sample}_T2T_markdup.bam"
	fixed_sorted_bam="$tmp/${sample}_fixed_sorted.bam"

	# SORTING AND DUPLICATE MARKING PREP
	samtools collate -@ 4 -O -T "$tmp/${sample}_collate_tmp" "$bam" | samtools fixmate -@ 4 -m - - | samtools sort -@ 4 -m 2G -T "$tmp/${sample}_sort_tmp" -o "$fixed_sorted_bam" -

	# DUPLICATE MARKING
	samtools markdup -@ 4 -s "$fixed_sorted_bam" "$out"
	samtools index "$out"

	# STATISTICS GENERATION
	samtools flagstat "$out" > "$mapped/${sample}_T2T_flagstat.txt"
	samtools idxstats "$out" > "$mapped/${sample}_T2T_idxstats.txt"

  	# MAPPING QUALITY FILTERING >= 10
  	# This is written to a different file than the original.
	samtools view -@ 4 -b -q 10 -F 1024 "$out" -o "$mapped/${sample}_T2T_markdup_filt_nodup.bam"
	samtools index "$mapped/${sample}_T2T_markdup_filt_nodup.bam"

	# COVERAGE
	samtools coverage "$mapped/${sample}_T2T_markdup_filt_nodup.bam" > "$mapped/${sample}_T2T_final_coverage.txt"
	samtools coverage -m "$mapped/${sample}_T2T_markdup_filt_nodup.bam" > "$mapped/${sample}_T2T_final_coverage_histogram.txt"

	rm -f "$fixed_sorted_bam"
	rm -f "$tmp/${sample}"*tmp*
done
