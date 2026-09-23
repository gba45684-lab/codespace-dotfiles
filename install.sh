#!/usr/bin/env bash

set -e

echo "Installing global Gemini configuration..."

mkdir -p "$HOME/.gemini/commands"

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cp "$DOTFILES_DIR/.gemini/GEMINI.md" \
   "$HOME/.gemini/GEMINI.md"

if compgen -G "$DOTFILES_DIR/.gemini/commands/*.toml" > /dev/null; then
    cp "$DOTFILES_DIR/.gemini/commands/"*.toml \
       "$HOME/.gemini/commands/"
fi

echo ""
echo "Gemini global configuration installed."
echo ""

if command -v gemini >/dev/null 2>&1; then
    echo "Gemini CLI:"
    gemini --version
else
    echo "Gemini CLI is not installed yet."
fi

echo ""
echo "Done."
