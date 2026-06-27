#!/usr/bin/env bash
# Linux (Debian/Ubuntu)-specific install steps.

linux_install_deps() {
  local pm
  pm="$(detect_package_manager)"
  case "$pm" in
    apt)
      log_info "Installing apt packages..."
      run sudo apt-get update -qq
      if [ -f "$DOT_ROOT/packages/apt.txt" ]; then
        # shellcheck disable=SC2046
        run sudo apt-get install -y $(grep -vE '^\s*(#|$)' "$DOT_ROOT/packages/apt.txt" | tr '\n' ' ')
      fi
      ;;
    dnf|pacman|none)
      log_warn "Package manager $pm not yet supported. Install deps manually:"
      log_dim "  required: zsh tmux neovim git curl stow fzf fd-find ripgrep btop"
      ;;
  esac

  # Starship via official installer (apt version often outdated)
  if ! command -v starship >/dev/null 2>&1; then
    log_info "Installing starship..."
    run sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- -y
  fi
}
