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

base="/users1/cpca070092024/fmarinha"
ref_path="$base/projeto_estagio/data/raw"
sync="https://m226.syncusercontent.com/zip"

# Download
curl -o "$ref_path"/sample9.zip "$sync/c52fd58993b3b36fc71f7b1d97929e20/Sample_9.zip?linkcachekey=8d5e548e0&pid=c52fd58993b3b36fc71f7b1d97929e20&jid=8fb145ed" || echo "Sample 9 - Download failed" &
curl -o "$ref_path"/sample17.zip "$sync/https://bf98e96d20c2b7feccbc709c2c12cbf9/Sample_17.zip?linkcachekey=ecc5557a0&pid=bf98e96d20c2b7feccbc709c2c12cbf9&jid=f8b5f449" || echo "Sample 17 - Download failed" &
curl -o "$ref_path"/sample164.zip "$sync/551994dd07b37230fa9bbe1d74cad623/Sample_164.zip?linkcachekey=bce73dc20&pid=551994dd07b37230fa9bbe1d74cad623&jid=e0ee2f40" || echo "Sample 164 - Download failed" &
curl -o "$ref_path"/sample181.zip "$sync/108a64267d2962713dea37be155188a1/Sample_181.zip?linkcachekey=740b8c740&pid=108a64267d2962713dea37be155188a1&jid=3a858e66" || echo "Sample 181 - Download failed" &

wait

# Unzip
for f in "$ref_path"/*.zip; do 
	unzip -o "$f" -d "$ref_path" || echo "$f - Unzip failed" &
done

wait
