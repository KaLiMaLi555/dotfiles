#!/usr/bin/env bash
# Cross-platform post-install steps.

common_post_install() {
  set_default_shell_zsh
}

set_default_shell_zsh() {
  command -v zsh >/dev/null 2>&1 || { log_warn "zsh not installed — skipping shell change"; return 0; }

  local zsh_path; zsh_path="$(command -v zsh)"
  local current_shell="${SHELL:-$(getent passwd "$USER" 2>/dev/null | cut -d: -f7)}"

  if [ -n "$current_shell" ] && [ "$(basename "$current_shell")" = "zsh" ]; then
    log_ok "default shell already zsh"
    return 0
  fi

  log_info "setting default shell to zsh ($zsh_path)"

  # Ensure zsh is in /etc/shells (chsh requires it)
  if [ -f /etc/shells ] && ! grep -qxF "$zsh_path" /etc/shells; then
    log_dim "  adding $zsh_path to /etc/shells"
    if [ "$(id -u)" -eq 0 ]; then
      run sh -c "echo '$zsh_path' >> /etc/shells"
    elif command -v sudo >/dev/null 2>&1; then
      run sh -c "echo '$zsh_path' | sudo tee -a /etc/shells >/dev/null"
    else
      log_warn "  cannot edit /etc/shells (no root, no sudo) — chsh may fail"
    fi
  fi

  # Run chsh
  if [ "$(id -u)" -eq 0 ]; then
    run chsh -s "$zsh_path" "${USER:-root}" 2>&1 || log_warn "chsh failed — set manually: chsh -s $zsh_path"
  else
    if run chsh -s "$zsh_path" 2>&1; then :
    elif command -v sudo >/dev/null 2>&1; then
      run sudo chsh -s "$zsh_path" "$USER" || log_warn "chsh failed — set manually"
    else
      log_warn "chsh failed and no sudo available — set manually: chsh -s $zsh_path"
    fi
  fi

  log_ok "default shell now zsh — open a new terminal to use it"
}
