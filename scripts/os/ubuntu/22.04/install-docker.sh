#!/usr/bin/env bash
# Source: https://docs.docker.com/engine/install/ubuntu/
set -e
echo "* Uninstall old versions"
sudo apt-get remove -qq -y docker docker-engine docker.io containerd runc 2>/dev/null
echo "* Install using the repository"
echo "* Update apt package index and allow HTTPS"
sudo apt-get update -qq -y
sudo apt-get install -qq -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
echo "* Add Docker’s official GPG key"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "* Setup repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
echo "* Update apt package index"
sudo apt-get update -qq -y
echo "* Install Docker Engine, containerd, and Docker Compose"
sudo apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
