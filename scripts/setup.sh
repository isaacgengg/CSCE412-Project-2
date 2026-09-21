#!/usr/bin/env bash
# Project 2 — host bootstrap for Ubuntu 24.04 LTS on AWS EC2
set -euo pipefail

echo "[1/4] Base packages"
sudo apt-get update
sudo apt-get install -y ca-certificates curl git tree

echo "[2/4] Docker's official GPG key"
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "[3/4] Docker apt repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] \
https://download.docker.com/linux/ubuntu \
$(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

echo "[4/4] Docker Engine, CLI, buildx and the Compose v2 plugin"
sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
  docker-buildx-plugin docker-compose-plugin

# run docker without sudo
sudo groupadd -f docker
sudo usermod -aG docker "$USER"

echo
echo "Done. Log out and back in, then run: docker run hello-world"
docker --version
docker compose version
