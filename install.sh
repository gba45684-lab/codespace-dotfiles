#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo " Gemini Global Environment Installer"
echo "======================================"
echo ""

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --------------------------------------------------
# Directories
# --------------------------------------------------

mkdir -p "$HOME/.gemini/commands"
mkdir -p "$HOME/bin"

# --------------------------------------------------
# Global Gemini instructions
# --------------------------------------------------

cp "$DOTFILES_DIR/.gemini/GEMINI.md" \
   "$HOME/.gemini/GEMINI.md"

# --------------------------------------------------
# GitHub MCP secure wrapper
# --------------------------------------------------

cp "$DOTFILES_DIR/bin/github-mcp" \
   "$HOME/bin/github-mcp"

chmod +x "$HOME/bin/github-mcp"

echo "✓ Global GEMINI.md installed"
echo "✓ GitHub MCP wrapper installed"

# --------------------------------------------------
# Gemini CLI
# --------------------------------------------------

if ! command -v gemini >/dev/null 2>&1; then
    echo ""
    echo "Gemini CLI is not installed."
    echo "Install @google/gemini-cli and run this installer again."
    exit 0
fi

echo ""
echo "Gemini CLI:"
gemini --version

# --------------------------------------------------
# Helper: replace MCP safely
# --------------------------------------------------

remove_mcp() {
    local name="$1"
    gemini mcp remove --scope user "$name" >/dev/null 2>&1 || true
}

add_mcp() {
    local name="$1"
    shift
    remove_mcp "$name"
    gemini mcp add --scope user "$name" "$@"
}

# --------------------------------------------------
# MCP servers
# --------------------------------------------------

echo ""
echo "Configuring MCP servers..."

# Browser automation
add_mcp playwright \
    npx -y @playwright/mcp@latest

# Documentation
add_mcp context7 \
    --transport http \
    https://mcp.context7.com/mcp

# Supabase
add_mcp supabase \
    --transport http \
    https://mcp.supabase.com/mcp

# Vercel
add_mcp vercel \
    --transport http \
    -H "Authorization: Bearer \$VERCEL_TOKEN" \
    https://mcp.vercel.com

# Sentry
add_mcp sentry \
    --transport stdio \
    -e SENTRY_ACCESS_TOKEN=\$SENTRY_AUTH_TOKEN \
    npx -y @sentry/mcp-server@latest

# GitHub
add_mcp github \
    -e GEMINI_GITHUB_TOKEN=\$GEMINI_GITHUB_TOKEN \
    "$HOME/bin/github-mcp"

# --------------------------------------------------
# Verification
# --------------------------------------------------

echo ""
echo "======================================"
echo " MCP STATUS"
echo "======================================"
gemini mcp list

echo ""
echo "======================================"
echo " INSTALLATION COMPLETE"
echo "======================================"
echo ""
echo "Global configuration:"
echo "  $HOME/.gemini/GEMINI.md"
echo ""
echo "GitHub MCP wrapper:"
echo "  $HOME/bin/github-mcp"
echo ""
