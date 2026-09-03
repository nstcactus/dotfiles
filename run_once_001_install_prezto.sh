#!/usr/bin/env bash
set -euo pipefail

source "$HOME/.config/shell/homebrew.sh"

BREW_ZSH="$(brew --prefix)/bin/zsh"
PREZTO_DIR="${ZDOTDIR:-$HOME}/.zprezto"

# Ensure Homebrew zsh is a valid login shell
if ! grep -qx "$BREW_ZSH" /etc/shells; then
  echo "Adding $BREW_ZSH to /etc/shells…"
  echo "$BREW_ZSH" | sudo tee -a /etc/shells
fi

# Clone Prezto if missing
if [[ ! -d "$PREZTO_DIR" ]]; then
  echo "Cloning Prezto in $PREZTO_DIR…"
  git clone --recursive https://github.com/sorin-ionescu/prezto.git "$PREZTO_DIR"
fi

# Clone contrib if missing
if [[ ! -d "$PREZTO_DIR/contrib" ]]; then
  echo "Cloning Prezto contrib…"
  git clone --recurse-submodules https://github.com/belak/prezto-contrib "$PREZTO_DIR/contrib"
fi

# Change login shell
CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
if [[ "$CURRENT_SHELL" != "$BREW_ZSH" ]]; then
  echo "Changing shell to $BREW_ZSH… You may need to authenticate."
  chsh -s "$BREW_ZSH"
else
  echo "Shell is already $BREW_ZSH — skipping chsh."
fi
