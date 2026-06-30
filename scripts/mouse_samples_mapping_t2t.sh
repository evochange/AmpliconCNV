#!/bin/bash

#SBATCH --job-name=mouseSamplesMappingT2T
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=18G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate mouse_mapping

base="/users1/cpca070092024/fmarinha/projeto_estagio"
raw="$base/data/raw"
t2t="$base/data/references/t2t/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna"
out_t2t="$base/data/mapped/t2t"

samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

for sample in "${samples[@]}"; do
	r1=("$raw/$sample/"*_1.fastq.gz)
	r2=("$raw/$sample/"*_2.fastq.gz)

	bwa-mem2 mem -t 12 "$t2t" "$r1" "$r2" | samtools sort -@ 4 -o "$out_t2t/${sample}_T2T_bwamem2.bam"
	samtools index "$out_t2t/${sample}_T2T_bwamem2.bam"
done
