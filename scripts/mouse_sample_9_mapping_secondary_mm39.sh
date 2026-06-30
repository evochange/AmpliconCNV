#!/bin/bash

#SBATCH --job-name=mouseSample9MappingSecondarymm39
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
tmp="$base/tmp/mm39_tmp"
raw="$base/data/raw"
mm39_ref="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
out_mm39="$base/data/mapped/mm39"

r1=("$raw/Sample_9/"*_1.fastq.gz)
r2=("$raw/Sample_9/"*_2.fastq.gz)

bwa-mem2 mem -a -t 12 "$mm39_ref" "$r1" "$r2" | samtools sort -@ 4 -m 4G -T "$tmp/Sample_9_mm39_sort" -o "$out_mm39/Sample_9_mm39_secondary_bwamem2.bam"
samtools index "$out_mm39/Sample_9_mm39_secondary_bwamem2.bam"

rm -f "$tmp/Sample_9_mm39_sort"*
