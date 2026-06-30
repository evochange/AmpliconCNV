#!/bin/bash

#SBATCH --job-name=ERR9880211IndDownload
#SBATCH --time=4:00:00
#SBATCH --nodes=1
#SBATCH --mem=32G
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

base="/users1/cpca070092024/fmarinha"
ref_path="$base/projeto_estagio/data/references/mm39"
ensembl="https://ftp.ensembl.org/pub/release-115/fasta/mus_musculus/dna/"

chrm=( {1..19} X Y MT )

for chr in "${chrm[@]}"; do
	file="Mus_musculus.GRCm39.dna.chromosome.${chr}.fa.gz"
	curl -o "$ref_path/$file" "$ensembl/$file"
	gzip -d "$ref_path/$file"
done

ls -l "$ref_path" | sort
