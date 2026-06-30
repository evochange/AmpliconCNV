#!/bin/bash

#SBATCH --job-name=mouseSample9MappingSecondaryt2t
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
tmp="$base/tmp/t2t_tmp"
raw="$base/data/raw"
t2t_ref="$base/data/references/t2t/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna"
out_t2t="$base/data/mapped/t2t"

r1=("$raw/Sample_9/"*_1.fastq.gz)
r2=("$raw/Sample_9/"*_2.fastq.gz)

bwa-mem2 mem -a -t 12 "$t2t_ref" "$r1" "$r2" | samtools sort -@ 4 -m 4G -T "$tmp/Sample_9_t2t_sort" -o "$out_t2t/Sample_9_T2T_secondary_bwamem2.bam"
samtools index "$out_t2t/Sample_9_T2T_secondary_bwamem2.bam"

rm -f "$tmp/Sample_9_t2t_sort"*
