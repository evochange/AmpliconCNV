#!/bin/bash

# VARIABLES
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")
refs=("mm39" "t2t")

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
bed_dir="$base/results/analysis"
out="$base/results/analysis"
output_file="$out/summary_tool_intersection_Y_only.tsv"

# DIRS CREATION
mkdir -p "$out"

# Write header
echo -e "Sample\tBuild\tComparison\tOverlap_Y_BP\tOverlap_Y_Count" > "$output_file"

for sample in "${samples[@]}"; do
    for ref in "${refs[@]}"; do

        cnvnator_bed="${bed_dir}/${ref}/${sample}_${ref}_cnvnator.bed"
        freec_bed="${bed_dir}/${ref}/${sample}_${ref}_freec.bed"
        cnvkit_bed="${bed_dir}/${ref}/${sample}_${ref}_cnvkit.bed"

        # CNVnator vs FREEC
        result=$(bedtools intersect -a <(awk '$1=="Y"' "$cnvnator_bed") -b <(awk '$1=="Y"' "$freec_bed") -wo)
        bp=$(echo "$result" | awk '{sum+=$(NF)} END {print sum+0}')
        count=$(echo "$result" | grep -c .)
        echo -e "${sample}\t${ref}\tCNVnator_vs_FREEC\t${bp}\t${count}" >> "$output_file"

        # CNVnator vs CNVkit
        result=$(bedtools intersect -a <(awk '$1=="Y"' "$cnvnator_bed") -b <(awk '$1=="Y"' "$cnvkit_bed") -wo)
        bp=$(echo "$result" | awk '{sum+=$(NF)} END {print sum+0}')
        count=$(echo "$result" | grep -c .)
        echo -e "${sample}\t${ref}\tCNVnator_vs_CNVkit\t${bp}\t${count}" >> "$output_file"

        # FREEC vs CNVkit
        result=$(bedtools intersect -a <(awk '$1=="Y"' "$freec_bed") -b <(awk '$1=="Y"' "$cnvkit_bed") -wo)
        bp=$(echo "$result" | awk '{sum+=$(NF)} END {print sum+0}')
        count=$(echo "$result" | grep -c .)
        echo -e "${sample}\t${ref}\tFREEC_vs_CNVkit\t${bp}\t${count}" >> "$output_file"

    done
done

cat "$output_file"
