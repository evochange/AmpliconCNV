#!/bin/bash

#SBATCH --job-name=T2Tpipeline
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --mem=128G
#SBATCH --cpus-per-task=16
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

base="/users1/cpca070092024/fmarinha"
ref_path="$base/projeto_estagio/data/references/t2t"
ncbi_whole="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/056/825/265/GCA_056825265.1_T2T_mhaESC_v1.5/"
ncbi_ind="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/056/825/265/GCA_056825265.1_T2T_mhaESC_v1.5/GCA_056825265.1_T2T_mhaESC_v1.5_assembly_structure/Primary_Assembly/assembled_chromosomes/FASTA/"
ncbi_mt="https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/056/825/265/GCA_056825265.1_T2T_mhaESC_v1.5/GCA_056825265.1_T2T_mhaESC_v1.5_assembly_structure/non-nuclear/assembled_chromosomes/FASTA/"

curl -o "$ref_path"/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna.gz "$ncbi_whole"/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna.gz
gzip -d "$ref_path"/GCA_056825265.1_T2T_mhaESC_v1.5_genomic.fna.gz

chrm=( {1..19} X Y )

for chr in "${chrm[@]}"; do
	file="chr${chr}.fna.gz"
	curl -o "$ref_path/$file" "$ncbi_ind/$file"
	gzip -d "$ref_path/$file"
done

curl -o "$ref_path"/chrMT.fna.gz "$ncbi_mt"/chrMT.fna.gz
gzip -d "$ref_path"/chrMT.fna.gz

ls -l "$ref_path" | sort
