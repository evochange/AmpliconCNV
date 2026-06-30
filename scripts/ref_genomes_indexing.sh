#!/bin/bash

#SBATCH --job-name=refGenomesIndexing
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=18G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate mouse_mapping

base="/users1/cpca070092024/fmarinha/projeto_estagio"
t2t="$base/data/references/t2t/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna"
mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"

bwa-mem2 index "$t2t" &
bwa-mem2 index "$mm39" &

wait

samtools faidx "$t2t"
samtools faidx "$mm39"
