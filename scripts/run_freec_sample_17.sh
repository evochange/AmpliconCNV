#!/bin/bash

#SBATCH --job-name=runFreecSample17
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

# CONDA ACTIVATION
export PATH="/users1/cpca070092024/fmarinha/.conda/envs/env_freec/bin:$PATH"

# VARIABLES
sample="Sample_17"
run="1"
WINDOW_SIZE="default"   # 1st run: 250, 2nd run: 3000, 3rd run: nd

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"

# mm39
out_mm39="$base/results/freec/mm39"
ref_mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"
chr_mm39="$base/data/references/mm39/chrLen_mm39.txt"

# t2t
out_t2t="$base/results/freec/t2t"
ref_t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"
chr_t2t="$base/data/references/t2t/chrLen_t2t.txt"

# DIRS CREATION
mkdir -p "$out_mm39/$sample" "$out_t2t/$sample"

# CHROMOSSOME NAME AND LENGTH EXTRACTION
# Extracting main chromossomes to bypass disperse scaffolds (previous error where mm39 could not match them to a individual .fa file)
if [ ! -f "chrLen_mm39.txt" ]; then
    grep -E '^(chr)?([1-9]|1[0-9]|X|Y|MT|M)[[:space:]]' "${ref_mm39}.fai" | cut -f1,2 > "$chr_mm39"
fi

if [ ! -f "chrLen_t2t.txt" ]; then
    grep -E '^(chr)?([1-9]|1[0-9]|X|Y|MT|M)[[:space:]]' "${ref_t2t}.fai" | cut -f1,2 > "$chr_t2t"
fi

# mm39
cat > "$out_mm39/${sample}_mm39_${WINDOW_SIZE}_config${run}.txt" << EOF
[general]
chrLenFile=$base/data/references/mm39/chrLen_mm39.txt
ploidy=2
maxThreads=8
chrFiles=$base/data/references/mm39/chroms_links
outputDir=$out_mm39/$sample
sex=XX
minExpectedGC=0.35
maxExpectedGC=0.55
telocentromeric=5000

[sample]
mateFile=$bam_mm39
inputFormat=BAM
mateOrientation=0
EOF

freec -conf "$out_mm39/${sample}_mm39_${WINDOW_SIZE}_config${run}.txt"

mv "$out_mm39/$sample/${sample}_mm39_markdup.bam_ratio.txt" "$out_mm39/$sample/${sample}_mm39_win${WINDOW_SIZE}_run${run}_ratio.txt"
mv "$out_mm39/$sample/${sample}_mm39_markdup.bam_CNVs"      "$out_mm39/$sample/${sample}_mm39_win${WINDOW_SIZE}_run${run}_CNVs"
mv "$out_mm39/$sample/GC_profile.${WINDOW_SIZE}bp.cnp"       "$out_mm39/$sample/GC_profile_win${WINDOW_SIZE}_run${run}.cnp"

# T2T
cat > "$out_t2t/${sample}_T2T_${WINDOW_SIZE}_config${run}.txt" << EOF
[general]
chrLenFile=$base/data/references/t2t/chrLen_t2t.txt
ploidy=2
maxThreads=8
chrFiles=$base/data/references/t2t/clean_chroms
outputDir=$out_t2t/$sample
sex=XX
minExpectedGC=0.35
maxExpectedGC=0.55
telocentromeric=5000

[sample]
mateFile=$bam_t2t
inputFormat=BAM
mateOrientation=0
EOF

freec -conf "$out_t2t/${sample}_T2T_${WINDOW_SIZE}_config${run}.txt"

mv "$out_t2t/$sample/${sample}_T2T_markdup.bam_ratio.txt" "$out_t2t/$sample/${sample}_T2T_win${WINDOW_SIZE}_run${run}_ratio.txt"
mv "$out_t2t/$sample/${sample}_T2T_markdup.bam_CNVs"      "$out_t2t/$sample/${sample}_T2T_win${WINDOW_SIZE}_run${run}_CNVs"
mv "$out_t2t/$sample/GC_profile.${WINDOW_SIZE}bp.cnp"     "$out_t2t/$sample/GC_profile_win${WINDOW_SIZE}_run${run}.cnp"
