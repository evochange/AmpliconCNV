#!/bin/bash

# VARIABLES
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")
refs=("mm39" "t2t")

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
bed_dir="$base/results/analysis"
out="$base/results/analysis"
output_file="$out/summary_build_space_comparison.tsv"

mkdir -p "$out"

echo -e "Sample\tBuild\tCNVnator_only\tFREEC_only\tCNVkit_only\tCNVnator_FREEC\tCNVnator_CNVkit\tFREEC_CNVkit\tAll_three" > "$output_file"

for sample in "${samples[@]}"; do
    for ref in "${refs[@]}"; do

        cnvnator_bed="${bed_dir}/${ref}/${sample}_${ref}_cnvnator.bed"
        freec_bed="${bed_dir}/${ref}/${sample}_${ref}_freec.bed"
        cnvkit_bed="${bed_dir}/${ref}/${sample}_${ref}_cnvkit.bed"

        # UNIQUE BPS CNVNATOR
        cnvnator_only=$(bedtools subtract -a "$cnvnator_bed" -b "$freec_bed" | \
                        bedtools subtract -a - -b "$cnvkit_bed" | \
                        awk '{sum += $3-$2} END {print sum+0}')

        # UNIQUE BPS FREEC
        freec_only=$(bedtools subtract -a "$freec_bed" -b "$cnvnator_bed" | \
                     bedtools subtract -a - -b "$cnvkit_bed" | \
                     awk '{sum += $3-$2} END {print sum+0}')

        # UNIQUE BPS CNVKIT
        cnvkit_only=$(bedtools subtract -a "$cnvkit_bed" -b "$cnvnator_bed" | \
                      bedtools subtract -a - -b "$freec_bed" | \
                      awk '{sum += $3-$2} END {print sum+0}')

        # CNVNATOR + FREEC BPS
        cnvnator_freec=$(bedtools intersect -a "$cnvnator_bed" -b "$freec_bed" | \
                         bedtools subtract -a - -b "$cnvkit_bed" | \
                         awk '{sum += $3-$2} END {print sum+0}')

        # CNVNATOR + CNVKIT BPS
        cnvnator_cnvkit=$(bedtools intersect -a "$cnvnator_bed" -b "$cnvkit_bed" | \
                          bedtools subtract -a - -b "$freec_bed" | \
                          awk '{sum += $3-$2} END {print sum+0}')

        # FREEC + CNVKIT BPS
        freec_cnvkit=$(bedtools intersect -a "$freec_bed" -b "$cnvkit_bed" | \
                       bedtools subtract -a - -b "$cnvnator_bed" | \
                       awk '{sum += $3-$2} END {print sum+0}')

        # CNVNATOR + FREEC + CNVKIT BPS
        all_three=$(bedtools intersect -a "$cnvnator_bed" -b "$freec_bed" | \
                    bedtools intersect -a - -b "$cnvkit_bed" | \
                    awk '{sum += $3-$2} END {print sum+0}')

        echo -e "${sample}\t${ref}\t${cnvnator_only}\t${freec_only}\t${cnvkit_only}\t${cnvnator_freec}\t${cnvnator_cnvkit}\t${freec_cnvkit}\t${all_three}" >> "$output_file"

    done
done

cat "$output_file"
