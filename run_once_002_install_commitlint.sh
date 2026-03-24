#!/bin/bash
set -euo pipefail

# ----------------------------
# Determine Homebrew prefix and ensure its bin is in PATH
BREW_PREFIX=$(brew --prefix)
export PATH="$BREW_PREFIX/bin:$PATH"

# ----------------------------
# Ensure user-local npm global directory
USER_NPM_DIR="$HOME/.local"
mkdir -p "$USER_NPM_DIR"

# Configure npm to use user-local directory
npm config set prefix "$USER_NPM_DIR"
export PATH="$USER_NPM_DIR/bin:$PATH"

# ----------------------------
# Check if npm is installed
if ! command -v npm >/dev/null 2>&1; then
  echo "🚨 npm is not installed. Please install Node.js and npm via Homebrew…"
  exit 1
fi

# ----------------------------
# Install commitlint if missing
if ! command -v commitlint >/dev/null 2>&1; then
  echo "⚙️ commitlint not found. Installing commitlint locally to $USER_NPM_DIR…"
  npm install --global commitlint
else
  echo "✅ commitlint is already installed…"
fi

# Install @nstcactus/commitlint-config if missing
if ! npm list --global @nstcactus/commitlint-config >/dev/null 2>&1; then
  echo "⚙️ @nstcactus/commitlint-config not found. Installing locally…"
  npm install --global @nstcactus/commitlint-config
else
  echo "✅ @nstcactus/commitlint-config is already installed…"
fi

echo "🎉 commitlint setup complete!"
