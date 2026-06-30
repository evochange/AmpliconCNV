#!/bin/bash

#SBATCH --job-name=markdupmm39
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

base="/users1/cpca070092024/fmarinha/projeto_estagio"
mapped="$base/data/mapped/mm39"
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

for sample in "${samples[@]}"; do
    bam="$mapped/${sample}_mm39_bwamem2.bam"
    out="$mapped/${sample}_mm39_markdup.bam"

    samtools collate -@ 4 -O "$bam" | samtools fixmate -@ 4 -m - - | samtools sort -@ 4 -T "$mapped/${sample}_tmp" - | samtools markdup -@ 4 -s - "$out"

    samtools index "$out"

    samtools flagstat "$out" > "$mapped/${sample}_mm39_flagstat.txt"
    samtools idxstats "$out" > "$mapped/${sample}_mm39_idxstats.txt"

done
