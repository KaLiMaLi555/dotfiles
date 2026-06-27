#!/usr/bin/env bash
# macOS-specific install steps. Sourced from install.sh.

macos_install_deps() {
  if ! command -v brew >/dev/null 2>&1; then
    log_info "Installing Homebrew..."
    run /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  if [ -f "$DOT_ROOT/Brewfile" ]; then
    log_info "Running brew bundle (Brewfile)..."
    run brew bundle --file="$DOT_ROOT/Brewfile" --no-lock
  fi
  if [ -f "$DOT_ROOT/Brewfile.cask" ]; then
    log_info "Running brew bundle (Brewfile.cask)..."
    run brew bundle --file="$DOT_ROOT/Brewfile.cask" --no-lock
  fi
}
