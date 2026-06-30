#!/bin/bash

conda create -n env_amplicone -c conda-forge -c bioconda \
	python=3.12 \
	pandas=2.2.3 \
	numpy=2.1.2 \
	pysam=0.22.1 \
	biopython=1.84 \
	bowtie2=2.* \
	-y

cd /users1/cpca070092024/fmarinha/projeto_estagio/tools

git clone https://github.com/makovalab-psu/AmpliCoNE-tool.git
