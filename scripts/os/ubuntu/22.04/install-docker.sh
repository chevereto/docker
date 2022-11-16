#!/usr/bin/env bash
set -e
sudo apt-get remove -qq -y docker docker-engine docker.io containerd runc
sudo apt-get update -qq -y
sudo apt-get install -qq -y \
  ca-certificates \
  curl \
  gnupg \
  lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list >/dev/null
sudo apt-get update -qq -y
sudo apt-get install -qq -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
