#!/usr/bin/env bash
# Source: https://docs.docker.com/engine/install/ubuntu/
set -e
if (($EUID != 0)); then
  echo "[ERROR] Must execute with root privileges"
  exit
fi
echo "* Uninstall old versions"
apt-get remove -qq -y docker docker-engine docker.io containerd runc || true
echo "* Install using the repository"
echo "* Update apt package index and allow HTTPS"
apt-get update -qq -y
apt-get install -qq -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
echo "* Add Docker’s official GPG key"
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "* Setup repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "* Update apt package index"
apt-get update -qq -y
echo "* Install Docker Engine, containerd, and Docker Compose"
apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
