#!/bin/bash

#SBATCH --job-name=mouseSamplesDownload
#SBATCH --time=24:00:00
#SBATCH --nodes=1
#SBATCH --mem=16G
#SBATCH --cpus-per-task=4
#SBATCH --ntasks-per-node=1

#SBATCH --partition=fct

#SBATCH --account=cpca070092024

#SBATCH --qos=cpca070092024

#SBATCH --output=/users1/cpca070092024/fmarinha/projeto_estagio/scripts/logs/slurm-%j.out

# PATHS
base="/users1/cpca070092024/fmarinha"
out="$base/.conda/envs/env_amplicone/share/RepeatMasker/Libraries/famdb"

# DOWNLOAD
curl -L -C - -o "$out/dfam39_full.7.h5.gz" https://www.dfam.org/releases/Dfam_3.9/families/FamDB/dfam39_full.7.h5.gz

# UNZIP
gzip -d "$out/dfam39_full.7.h5.gz"

# TESTER SCRIPT
python3 "$base/.conda/envs/env_amplicone/share/RepeatMasker/Libraries/famdb.py" names mouse
