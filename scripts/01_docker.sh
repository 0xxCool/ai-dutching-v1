#!/usr/bin/env bash
# -------------------------------------------------------------
# ai-dutching-v1  |  Schritt 1.2  |  Docker + NVIDIA-Runtime
# -------------------------------------------------------------
set -euo pipefail

R='\e[31m';G='\e[32m';Y='\e[33m';B='\e[34m';N='\e[0m'

echo -e "${B}==> 1.2.1  Install Docker (official repo)${N}"
curl -fsSL https://get.docker.com | sudo bash -s -- --dry-run >/dev/null
curl -fsSL https://get.docker.com | sudo bash

echo -e "${B}==> 1.2.2  User in docker-Gruppe${N}"
sudo usermod -aG docker $USER
# aktive Shell bekommt neue Gruppe ohne logout/newgrp
newgrp docker <<EOS
docker --version
EOS

echo -e "${B}==> 1.2.3  NVIDIA Container Toolkit${N}"
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update -qq
sudo apt-get install -y -qq nvidia-container-toolkit
sudo systemctl restart docker

echo -e "${B}==> 1.2.4  Test GPU in Docker${N}"
docker run --rm --gpus all nvidia/cuda:12.2.0-base-ubuntu22.04 nvidia-smi

echo -e "${B}==> 1.2.5  Docker-Compose (v2)${N}"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version

echo -e "${B}==> 1.2.6  Git-Snapshot${N}"
git add .
git commit -m "chore: docker + nvidia-runtime Schritt 1.2"
git push origin main

echo -e "${G}✅ Docker bereit – Gruppe aktiv nach nächstem Login (oder newgrp docker)${N}"
