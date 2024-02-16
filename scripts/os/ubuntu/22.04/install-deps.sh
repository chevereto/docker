#!/usr/bin/env bash
set -e
if (($EUID != 0)); then
  echo "[ERROR] Must execute with root privileges"
  exit 1
fi
echo "* Update apt package index"
apt-get update -qq -y
echo "* Installing make unzip curl git jq"
apt-get install -qq -y make unzip curl git jq
echo "[OK] Dependencies ready"
