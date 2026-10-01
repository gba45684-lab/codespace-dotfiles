#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$HOME/codespace-dotfiles"

if [ ! -d "$REPO_DIR/.git" ]; then
    git clone https://github.com/gba45684-lab/codespace-dotfiles "$REPO_DIR"
fi

cd "$REPO_DIR"
git pull --ff-only origin main
bash install.sh

echo ""
echo "======================================"
echo " GLOBAL CODESPACE SETUP READY"
echo "======================================"
