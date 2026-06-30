#!/bin/bash

#SBATCH --job-name=mouseSamplesMappingmm39
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
mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
out_mm39="$base/data/mapped/mm39"

samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

for sample in "${samples[@]}"; do
	r1=("$raw/$sample/"*_1.fastq.gz)
	r2=("$raw/$sample/"*_2.fastq.gz)

	bwa-mem2 mem -t 12 "$mm39" "$r1" "$r2" | samtools sort -@ 4 -o "$out_mm39/${sample}_mm39_bwamem2.bam"
	samtools index "$out_mm39/${sample}_mm39_bwamem2.bam"
done
