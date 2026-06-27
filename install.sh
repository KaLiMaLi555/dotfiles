#!/usr/bin/env bash
# install.sh — dotfiles bootstrap.
# Usage:
#   ./install.sh                          # auto-detect profile
#   ./install.sh --profile=mac-personal   # explicit profile
#   ./install.sh --only=tmux,zsh          # link only these packages
#   DRY_RUN=1 ./install.sh                # show what would happen, change nothing
#
# Idempotent: safe to re-run after every pull.

set -euo pipefail

# ── Resolve repo root ─────────────────────────────────────────────────────
DOT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOT_ROOT

# Self-clone when invoked via `curl | bash`
if [ ! -d "$DOT_ROOT/stow" ] && [ ! -d "$HOME/dotfiles/stow" ]; then
  echo "▸ Cloning dotfiles into ~/dotfiles ..."
  git clone https://github.com/KaLiMaLi555/dotfiles "$HOME/dotfiles"
  exec "$HOME/dotfiles/install.sh" "$@"
fi
if [ ! -d "$DOT_ROOT/stow" ] && [ -d "$HOME/dotfiles/stow" ]; then
  DOT_ROOT="$HOME/dotfiles"
fi

# shellcheck disable=SC1091
. "$DOT_ROOT/lib/log.sh"
. "$DOT_ROOT/lib/detect.sh"
. "$DOT_ROOT/lib/run.sh"
. "$DOT_ROOT/lib/expand-profile.sh"
. "$DOT_ROOT/lib/link.sh"
. "$DOT_ROOT/lib/render.sh"
. "$DOT_ROOT/lib/ensure-local.sh"

# ── Parse args ───────────────────────────────────────────────────────────
PROFILE=""
ONLY=""
for arg in "$@"; do
  case "$arg" in
    --profile=*) PROFILE="${arg#*=}" ;;
    --only=*)    ONLY="${arg#*=}" ;;
    --dry-run)   DRY_RUN=1 ;;
    -h|--help)   sed -n '2,10p' "$0"; exit 0 ;;
    *) die "Unknown arg: $arg" ;;
  esac
done

[ -z "$PROFILE" ] && PROFILE="$(detect_default_profile)"
OS="$(detect_os)"

log_step "dotfiles install"
log_info "profile : $PROFILE"
log_info "os      : $OS"
log_info "root    : $DOT_ROOT"
[ "${DRY_RUN:-0}" = "1" ] && log_warn "DRY_RUN=1 — no changes will be made"

# ── 1. Install system deps ────────────────────────────────────────────────
log_step "1/5 Install system dependencies"
case "$OS" in
  macos) . "$DOT_ROOT/os/macos/install.sh"; macos_install_deps ;;
  linux) . "$DOT_ROOT/os/linux/install.sh"; linux_install_deps ;;
esac

if ! command -v stow >/dev/null 2>&1; then
  die "stow not found after install — bailing"
fi

# ── 2. Render templates ───────────────────────────────────────────────────
log_step "2/5 Render templates"
render_templates "$PROFILE"

# ── 3. Resolve which packages to stow ─────────────────────────────────────
log_step "3/5 Resolve packages from profile"
pkgs=()
while IFS= read -r line; do pkgs+=("$line"); done < <(expand_profile "$PROFILE")
if [ -n "$ONLY" ]; then
  IFS=',' read -r -a only_arr <<< "$ONLY"
  filtered=()
  for p in "${pkgs[@]}"; do
    for o in "${only_arr[@]}"; do
      [ "$p" = "$o" ] && filtered+=("$p") && break
    done
  done
  pkgs=("${filtered[@]}")
fi
log_info "packages: ${pkgs[*]}"

# ── 4. Stow packages ──────────────────────────────────────────────────────
log_step "4/5 Stow packages"
for p in "${pkgs[@]}"; do
  log_info "linking $p"
  stow_link "$p"
done

# ── 5. Local overlay + post-install ───────────────────────────────────────
log_step "5/5 Local overlay + post-install"
ensure_local_files
. "$DOT_ROOT/os/common/install.sh"
common_post_install

log_step "Done"
log_ok "dotfiles linked. Open a new shell or: exec zsh"
