#!/bin/bash

#SBATCH --job-name=runFreecSample164
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=8G
#SBATCH --cpus-per-task=8
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate env_freec

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
mm39="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
t2t="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
out="$base/results/freec"
sample="Sample_164"

# BAM PATHS
bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"
bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"

WINDOW_SIZE=250

# REFERENCE PREPARATION
if [ ! -f "${mm39}.fai" ]; then samtools faidx "$mm39"; fi
if [ ! -f "${t2t}.fai" ]; then samtools faidx "$t2t"; fi

# CHROMOSSOME NAME AND LENGTH EXTRACTION
# Extracting main chromossomes to bypass disperse scaffolds (previous error where mm39 could not match them to a individual .fa file)
grep -E '^(chr)?([1-9]|1[0-9]|X|Y|MT|M)[[:space:]]' "${mm39}.fai" | cut -f1,2 > "$base/data/references/mm39/chrLen_mm39.txt"

cut -f1,2 "${t2t}.fai" > "$base/data/references/t2t/chrLen_t2t.txt"

# OUTPUTS
mkdir -p "$out/mm39/$sample"
mkdir -p "$out/t2t/$sample"

# mm39
cat > "$out/${sample}_mm39_config.txt" << EOF
[general]
chrLenFile=$base/data/references/mm39/chrLen_mm39.txt
ploidy=2
maxThreads=8
window=$WINDOW_SIZE
chrFiles=$base/data/references/mm39/chroms_links
outputDir=$out/mm39/$sample
sex=XY

[sample]
mateFile=$bam_mm39
inputFormat=BAM
mateOrientation=0
EOF

freec -conf "$out/${sample}_mm39_config.txt"

# T2T
cat > "$out/${sample}_T2T_config.txt" << EOF
[general]
chrLenFile=$base/data/references/t2t/chrLen_t2t.txt
ploidy=2
maxThreads=8
window=$WINDOW_SIZE
chrFiles=$base/data/references/t2t/clean_chroms
outputDir=$out/t2t/$sample
sex=XY

[sample]
mateFile=$bam_t2t
inputFormat=BAM
mateOrientation=0
EOF

freec -conf "$out/${sample}_T2T_config.txt"
