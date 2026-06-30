#!/bin/bash

#SBATCH --job-name=runAmpliconeSample164
#SBATCH --time=72:00:00
#SBATCH --nodes=1
#SBATCH --mem-per-cpu=16G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

conda activate env_amplicone

# PATHS
base="/users1/cpca070092024/fmarinha/projeto_estagio"
tool_dir="$base/tools/AmpliCoNE-tool"
sample="Sample_164"
mm39_fa="$base/data/references/mm39/Mus_musculus.GRCm39.dna.primary_assembly.fa"
t2t_fa="$base/data/references/t2t/GCA_056825265.1_T2T_renamed.fna"
bam_mm39="$base/data/mapped/mm39/${sample}_mm39_markdup.bam"
bam_t2t="$base/data/mapped/t2t/${sample}_T2T_markdup.bam"
out_mm39="$base/results/amplicone/mm39/$sample"
out_t2t="$base/results/amplicone/t2t/$sample"

# CREATING DIRS
mkdir -p "$out_mm39"
mkdir -p "$out_t2t"

# CUSTOM MOUSE ANNOTATION TABLE INPUTS
mm39_gene_def="$base/data/references/mm39/amplicone_files/gene_definition_mm39.tab"
mm39_annotation="$base/data/references/mm39/amplicone_files/mm39_Ychromosome_annotation.tab"

t2t_gene_def="$base/data/references/t2t/amplicone_files/gene_definition_t2t.tab"
t2t_annotation="$base/data/references/t2t/amplicone_files/t2t_Ychromosome_annotation.tab"

if [ ! -f "${mm39_fa}.fai" ]; then
    samtools faidx "$mm39_fa"
fi

# MM39 ASSEMBLY TRACK
# Y chromossome length
MM39_Y_LEN=$(awk '$1=="Y" || $1=="chrY" {print $2}' "${mm39_fa}.fai")

python "$tool_dir/AmpliCoNE-count.py" \
    --GENE_DEF "$mm39_gene_def" \
    --ANNOTATION "$mm39_annotation" \
    --BAM "$bam_mm39" \
    --CHR "Y" \
    --LENGTH "$MM39_Y_LEN" \
    --READ PAIRED

mv *Ampliconic_Summary.txt *XDG_CopyNumber.txt "$out_mm39/"

if [ ! -f "${t2t_fa}.fai" ]; then
    samtools faidx "$t2t_fa"
fi

# T2T ASSEMBLY TRACK
# Y chromossome length
T2T_Y_LEN=$(awk '$1=="Y" || $1=="chrY" {print $2}' "${t2t_fa}.fai")

python "$tool_dir/AmpliCoNE-count.py" \
    --GENE_DEF "$t2t_gene_def" \
    --ANNOTATION "$t2t_annotation" \
    --BAM "$bam_t2t" \
    --CHR "Y" \
    --LENGTH "$T2T_Y_LEN" \
    --READ PAIRED

mv *Ampliconic_Summary.txt *XDG_CopyNumber.txt "$out_t2t/"
