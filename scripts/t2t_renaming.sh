#!/bin/bash

#SBATCH --job-name=t2tRenaming
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=4G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1
#SBATCH --exclude=hpc030

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate mouse_mapping

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
mapped="$base/data/mapped/t2t"
tmp="$base/tmp/t2t_tmp/"
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")

for sample in "${samples[@]}"; do
    for suffix in "T2T_markdup"; do
        bam="$mapped/${sample}_${suffix}.bam"

        # HEADER REWRITING
        samtools view -@ 6 -h "$bam" \
            | sed \
                -e 's/CM166248\.1/1/g' \
                -e 's/CM166249\.1/2/g' \
                -e 's/CM166250\.1/3/g' \
                -e 's/CM166251\.1/4/g' \
                -e 's/CM166252\.1/5/g' \
                -e 's/CM166253\.1/6/g' \
                -e 's/CM166254\.1/7/g' \
                -e 's/CM166255\.1/8/g' \
                -e 's/CM166256\.1/9/g' \
                -e 's/CM166257\.1/10/g' \
                -e 's/CM166258\.1/11/g' \
                -e 's/CM166259\.1/12/g' \
                -e 's/CM166260\.1/13/g' \
                -e 's/CM166261\.1/14/g' \
                -e 's/CM166262\.1/15/g' \
                -e 's/CM166263\.1/16/g' \
                -e 's/CM166264\.1/17/g' \
                -e 's/CM166265\.1/18/g' \
                -e 's/CM166266\.1/19/g' \
                -e 's/CM166267\.1/X/g' \
                -e 's/CM166268\.1/Y/g' \
                -e 's/CM166269\.1/MT/g' \
            | samtools view -@ 6 -b -o "$tmp/${sample}_${suffix}_renamed.bam"

        samtools index "$tmp/${sample}_${suffix}_renamed.bam"

        # ORIGINAL REPLACING
        mv "$tmp/${sample}_${suffix}_renamed.bam" "$bam"
        mv "$tmp/${sample}_${suffix}_renamed.bam.bai" "${bam}.bai"
    done
done
