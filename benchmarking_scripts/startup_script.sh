#! /bin/bash

# To execute MinIO on each Server:...
sudo apt-get install wget
sudo wget https://dl.min.io/server/minio/release/linux-amd64/minio
sudo wget https://dl.min.io/client/mc/release/linux-amd64/mc
sudo chmod +x minio
sudo chmod +x mc
sudo mv minio /usr/local/bin/minio
sudo mv mc /usr/local/bin/mc
sudo minio server http://min-{1...4}/mnt/disks/disk{1...4} &
echo "end"
