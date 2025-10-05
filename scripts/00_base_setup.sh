#!/usr/bin/env bash
# -------------------------------------------------------------
# ai-dutching-v1  |  Schritt 1.1  |  Basis-Setup (RTX 4090)
# -------------------------------------------------------------
set -euo pipefail

# Farben
R='\e[31m';G='\e[32m';Y='\e[33m';B='\e[34m';N='\e[0m'

echo -e "${B}==> 1.1.1  Ubuntu Updates${N}"
sudo apt-get update -qq && sudo apt-get dist-upgrade -y -qq

echo -e "${B}==> 1.1.2  Essentials${N}"
sudo apt-get install -y -qq \
  build-essential git curl wget htop tmux unzip jq nvtop \
  python3.11 python3.11-venv python3.11-dev python3-pip \
  software-properties-common apt-transport-https ca-certificates gnupg lsb-release

echo -e "${B}==> 1.1.3  Python-Venv${N}"
python3.11 -m venv venv
source venv/bin/activate
pip install -U pip setuptools wheel

echo -e "${B}==> 1.1.4  Core-Pakete (nur Basis für spätere requirements)${N}"
pip install --no-cache-dir \
  numpy pandas scikit-learn scipy jupyter matplotlib seaborn

echo -e "${B}==> 1.1.5  Git-Snapshot${N}"
git add .
git commit -m "chore: basis-setup Schritt 1.1"
git push origin main

echo -e "${G}✅ Basis-Setup fertig – venv ist aktiv!${N}"
echo -e "${Y}Nächster Schritt: 1.2  (Docker + Docker-Compose installieren)${N}"
