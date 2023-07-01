#!/usr/bin/bash

sudo nala update

wget https://dl.min.io/server/minio/release/linux-amd64/minio
sudo chmod +x minio
sudo mv minio /usr/local/bin
sudo useradd -r minio-user -s /sbin/nologin
sudo chown minio-user:minio-user /usr/local/bin/minio
sudo mkdir /usr/local/share/minio
sudo chown minio-user:minio-user /usr/local/share/minio
sudo mkdir /etc/minio
sudo chown minio-user:minio-user /etc/minio

#sudo nano /etc/default/minio
echo 'MINIO_VOLUMES="/usr/local/share/minio/"' | sudo tee -a /etc/default/minio
echo 'MINIO_OPTS="127.0.0.1:9000"' | sudo tee -a /etc/default/minio
echo 'MINIO_ACCESS_KEY="minioadmin"' | sudo tee -a /etc/default/minio
echo 'MINIO_SECRET_KEY="minioadmin"' | sudo tee -a /etc/default/minio

curl -O https://raw.githubusercontent.com/minio/minio-service/master/linux-systemd/minio.service

# nano minio.service
sudo mv minio.service /etc/systemd/system

sudo ufw enable
sudo ufw allow 9000/tcp

sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio
sudo systemctl status minio

