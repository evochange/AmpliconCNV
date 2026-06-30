#!/bin/bash

#SBATCH --job-name=mouseSample181Mappingt2t
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

r1=("$raw/Sample_181/"*_1.fastq.gz)
r2=("$raw/Sample_181/"*_2.fastq.gz)

bwa-mem2 mem -t 14 "$t2t" "$r1" "$r2" | samtools sort -@ 1 -m 4G -T "$out_t2t/Sample_181_tmp" -o "$out_t2t/Sample_181_T2T_bwamem2.bam"
samtools index "$out_t2t/Sample_181_T2T_bwamem2.bam"
