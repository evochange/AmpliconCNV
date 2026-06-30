#!/bin/bash

# VARIABLES
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")
run="1"

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"

# mm39
out_mm39="$base/results/analysis/mm39"
cnvnator_mm39="$base/results/cnvnator/mm39"
freec_mm39="$base/results/freec/mm39"
cnvkit_mm39="$base/results/cnvkit/mm39/run1"

# t2t
out_t2t="$base/results/analysis/t2t"
cnvnator_t2t="$base/results/cnvnator/t2t"
freec_t2t="$base/results/freec/t2t"
cnvkit_t2t="$base/results/cnvkit/t2t/run1"

# DIRS CREATION
mkdir -p "$out_mm39" "$out_t2t"

for sample in "${samples[@]}"; do
    # mm39

    # CNVnator
    awk 'BEGIN{OFS="\t"} {
        split($2, a, ":"); split(a[2], b, "-");
        print a[1], b[1]-1, b[2], $1
    }' "${cnvnator_mm39}/${sample}_mm39_bin3000_calls.txt" > "${out_mm39}/${sample}_mm39_cnvnator.bed"

    # FREEC
    awk 'BEGIN{OFS="\t"} {
        start = $2 - 1
        if (start < 0) start = 0
        print $1, start, $3, $5"_"$4
    }' "${freec_mm39}/${sample}/${sample}_mm39_windefault_run1_CNVs" > "${out_mm39}/${sample}_mm39_freec.bed"

    # CNVkit
    if [ "$sample" == "Sample_17" ]; then
        cnvkit_run_mm39="$base/results/cnvkit/mm39/run2"
        cnvkit_run_t2t="$base/results/cnvkit/t2t/run2"
    else
        cnvkit_run_mm39="$base/results/cnvkit/mm39/run1"
        cnvkit_run_t2t="$base/results/cnvkit/t2t/run1"
    fi

    # mm39
    awk 'BEGIN{OFS="\t"} NR>1 && $6!=2 {print $1, $2, $3, "cn"$6}' \
        "${cnvkit_run_mm39}/${sample}_mm39_markdup.call.cns" > "${out_mm39}/${sample}_mm39_cnvkit.bed"
done

for sample in "${samples[@]}"; do
    # T2T

    # CNVnator
    awk 'BEGIN{OFS="\t"} {
        split($2, a, ":"); split(a[2], b, "-");
        print a[1], b[1]-1, b[2], $1
    }' "${cnvnator_t2t}/${sample}_T2T_bin3000_calls.txt" > "${out_t2t}/${sample}_t2t_cnvnator.bed"

    # FREEC
    awk 'BEGIN{OFS="\t"} {
        start = $2 - 1
        if (start < 0) start = 0
        print $1, start, $3, $5"_"$4
    }' "${freec_t2t}/${sample}/${sample}_T2T_windefault_run1_CNVs" > "${out_t2t}/${sample}_t2t_freec.bed"

    # CNVkit
    if [ "$sample" == "Sample_17" ]; then
        cnvkit_run_mm39="$base/results/cnvkit/mm39/run2"
        cnvkit_run_t2t="$base/results/cnvkit/t2t/run2"
    else
        cnvkit_run_mm39="$base/results/cnvkit/mm39/run1"
        cnvkit_run_t2t="$base/results/cnvkit/t2t/run1"
    fi

    awk 'BEGIN{OFS="\t"} NR>1 && $6!=2 {print $1, $2, $3, "cn"$6}' \
        "${cnvkit_run_t2t}/${sample}_T2T_markdup.call.cns" > "${out_t2t}/${sample}_t2t_cnvkit.bed"
done
