#!/bin/bash

#SBATCH --job-name=refGenomesMasking
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

set -e

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_amplicone/bin:$PATH"

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
out_dir="$base/data/references/masks"

# mm39
tmp_mm39="$base/tmp/mm39_tmp"
ref_mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"

# T2T
tmp_t2t="$base/tmp/t2t_tmp"
ref_t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"

# DIR CREATION
mkdir -p "$out_dir"

rm -rf "$tmp_mm39/mm39_index"

# mm39
# GEM
genmap index -F "$ref_mm39" -I "$tmp_mm39/mm39_index"
genmap map -I "$tmp_mm39/mm39_index" -O "$tmp_mm39/mm39_map" -K 101 -E 2 --bedgraph
mv "$tmp_mm39/mm39_map.bedgraph" "$out_dir/mm39.mappability.bed"

# REPEATMASKER
samtools faidx "$ref_mm39" "Y" > "$tmp_mm39/mm39_chrY.fa"
cd "$tmp_mm39"
RepeatMasker -pa 16 -xsmall -e ncbi -species "Mus musculus" "mm39_chrY.fa"

# SAVING FOR STEP 3
mv "mm39_chrY.fa.out" "$out_dir/mm39_chrY.repeatmasker.out"

# TRF
trf "mm39_chrY.fa" 2 7 7 80 10 50 500 -f -d -h -m
mv "mm39_chrY.fa.masked" "$out_dir/mm39_chrY.fa.masked"

#.dat to BED conversion
awk -v chr="Y" 'BEGIN{OFS="\t"} NR>6 && $1 ~ /^[0-9]+$/ {print chr, $1, $2, $13}' "mm39_chrY.fa.2.7.7.80.10.50.500.dat" > "$out_dir/mm39_chrY.trf.bed"

# T2T
# GEM
cd "$base"
rm -rf "$tmp_t2t/t2t_index"

genmap index -F "$ref_t2t" -I "$tmp_t2t/t2t_index"
genmap map -I "$tmp_t2t/t2t_index" -O "$tmp_t2t/t2t_map" -K 101 -E 2 --bedgraph
mv "$tmp_t2t/t2t_map.bedgraph" "$out_dir/t2t.mappability.bed"

# REPEATMASKER
samtools faidx "$ref_t2t" "Y" > "$tmp_t2t/t2t_chrY.fa"
cd "$tmp_t2t"
RepeatMasker -pa 16 -xsmall -e ncbi -species "Mus musculus" "t2t_chrY.fa"

# SAVING FOR STEP 3
mv "t2t_chrY.fa.out" "$out_dir/t2t_chrY.repeatmasker.out"

# TRF
trf "t2t_chrY.fa" 2 7 7 80 10 50 500 -f -d -h -m
mv "t2t_chrY.fa.masked" "$out_dir/t2t_chrY.fa.masked"

# .dat to BED conversion
awk -v chr="Y" 'BEGIN{OFS="\t"} NR>6 && $1 ~ /^[0-9]+$/ {print chr, $1, $2, $13}' "t2t_chrY.fa.2.7.7.80.10.50.500.dat" > "$out_dir/t2t_chrY.trf.bed"
