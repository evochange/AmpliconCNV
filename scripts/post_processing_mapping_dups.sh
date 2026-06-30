#!/bin/bash

#SBATCH --job-name=postProcessingMappingDups
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate mouse_mapping

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

# mm39 DUPS
mapped="$base/data/mapped/mm39"
for sample in "${samples[@]}"; do
	out="$mapped/${sample}_mm39_markdup.bam"
	filt="$mapped/${sample}_mm39_markdup_filt.bam"

	samtools view -@ 4 -b -q 10 "$out" -o "$filt"
	samtools index "$filt"
done

# T2T DUPS
mapped="$base/data/mapped/t2t"
for sample in "${samples[@]}"; do
	out="$mapped/${sample}_T2T_markdup.bam"
	filt="$mapped/${sample}_T2T_markdup_filt.bam"

	samtools view -@ 4 -b -q 10 "$out" -o "$filt"
	samtools index "$filt"
done
