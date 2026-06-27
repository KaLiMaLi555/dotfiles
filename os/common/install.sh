#!/usr/bin/env bash
# Cross-platform post-install steps.

common_post_install() {
  # Make zsh the default shell if it isn't already
  if command -v zsh >/dev/null 2>&1; then
    if [ -n "$SHELL" ] && [ "$(basename "$SHELL")" != "zsh" ]; then
      log_info "Default shell is $SHELL — change to zsh with: chsh -s \"\$(which zsh)\""
    fi
  fi
}
