#!/bin/bash

# VARIABLES
samples=("Sample_9" "Sample_17" "Sample_164" "Sample_181")
run="1"

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
out="$base/results/analysis"
output_file="$out/summary_cnv_raw_counts_autosomes.tsv"

# DIRS CREATION
mkdir -p "$out"

# OVERWRITE OLD DATA
echo -e "Sample\tBuild\tCNVnator_Auto\tCNVkit_Auto\tFREEC_Auto" > "$output_file"

for sample in "${samples[@]}"; do

    # CNVkit's exception
    if [ "$sample" == "Sample_17" ]; then
        cnvkit_run="run2"
    else
        cnvkit_run="run1"
    fi

    # mm39
    cnvnator_mm39="$base/results/cnvnator/mm39/${sample}_mm39_bin3000_calls.txt"
    freec_mm39="$base/results/freec/mm39/$sample/${sample}_mm39_windefault_run1_CNVs"
    cnvkit_mm39="$base/results/cnvkit/mm39/${cnvkit_run}/${sample}_mm39_markdup.call.cns"

    cnvnator_39=$( [ -f "$cnvnator_mm39" ] && awk '$2 ~ /^([0-9]+|chr[0-9]+):/' "$cnvnator_mm39" | wc -l)
    freec_39=$( [ -f "$freec_mm39" ] && awk '$1 ~ /^[0-9]+$/' "$freec_mm39" | wc -l)
    cnvkit_39=$( [ -f "$cnvkit_mm39" ] && awk 'NR>1 && $1 ~ /^[0-9]+$/ && $6 != 2' "$cnvkit_mm39" | wc -l)

    echo -e "${sample}\tmm39\t${cnvnator_39}\t${cnvkit_39}\t${freec_39}" >> "$output_file"

    # T2T
    cnvnator_t2t="$base/results/cnvnator/t2t/${sample}_T2T_bin3000_calls.txt"
    freec_t2t="$base/results/freec/t2t/$sample/${sample}_T2T_windefault_run1_CNVs"
    cnvkit_t2t="$base/results/cnvkit/t2t/${cnvkit_run}/${sample}_T2T_markdup.call.cns"

    cnvnator_t2t_count=$( [ -f "$cnvnator_t2t" ] && awk '$2 ~ /^([0-9]+|chr[0-9]+):/' "$cnvnator_t2t" | wc -l)
    freec_t2t_count=$( [ -f "$freec_t2t" ] && awk '$1 ~ /^[0-9]+$/' "$freec_t2t" | wc -l)
    cnvkit_t2t_count=$( [ -f "$cnvkit_t2t" ] && awk 'NR>1 && $1 ~ /^[0-9]+$/ && $6 != 2' "$cnvkit_t2t" | wc -l)

    echo -e "${sample}\tt2t\t${cnvnator_t2t_count}\t${cnvkit_t2t_count}\t${freec_t2t_count}" >> "$output_file"
done

# TOTAL
awk -F'\t' '
    NR > 1 {
        v_nator += $3;
        v_kit += $4;
        v_freec += $5
    }
    END {
        print "TOTAL\t-\t" v_nator "\t" v_kit "\t" v_freec
    }
' "$output_file" >> "$output_file"

cat "$output_file"
