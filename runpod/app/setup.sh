#!/bin/bash

# Arrête le script dès qu'une commande échoue
set -e

# Création du dossier audio_cache à la racine
mkdir -p /audio_cache

# Mise à jour des paquets et installation des dépendances système
apt-get update && apt-get install -y --no-install-recommends \
    postgresql \
    postgresql-contrib \
    postgresql-server-dev-all \
    build-essential \
    git \
    ca-certificates \
    curl \
&& rm -rf /var/lib/apt/lists/*

# Compilation et installation de pgvector
git clone --branch v0.7.4 --depth 1 https://github.com/pgvector/pgvector.git /tmp/pgvector
cd /tmp/pgvector && make && make install
rm -rf /tmp/pgvector

# Clonage et configuration du projet
cd /
git clone https://github.com/Ndongis/ia_culturel_app.git
cd /ia_culturel_app

# Installation des dépendances Python
pip install --no-cache-dir -r requirements.txt
pip uninstall -y torch torchvision torchaudio
pip install -U torch --index-url https://download.pytorch.org/whl/cu124

# Lancement de l'entrypoint
sh entrypoint.sh