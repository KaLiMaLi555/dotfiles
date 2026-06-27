#!/usr/bin/env bash
# uninstall.sh — unlink stow packages and restore latest backup.
# Does NOT remove brew/apt packages — prints them as a checklist.

set -euo pipefail
DOT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOT_ROOT

# shellcheck disable=SC1091
. "$DOT_ROOT/lib/log.sh"
. "$DOT_ROOT/lib/detect.sh"
. "$DOT_ROOT/lib/run.sh"
. "$DOT_ROOT/lib/expand-profile.sh"
. "$DOT_ROOT/lib/link.sh"

PROFILE="${1:-$(detect_default_profile)}"
log_step "Uninstalling profile: $PROFILE"

pkgs=()
while IFS= read -r line; do pkgs+=("$line"); done < <(expand_profile "$PROFILE")
for p in "${pkgs[@]}"; do
  log_info "unlinking $p"
  stow_unlink "$p"
done

latest_backup="$(find "$DOT_ROOT/.backup" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | tail -1)"
if [ -n "$latest_backup" ]; then
  log_info "Restoring backup: $latest_backup"
  find "$latest_backup" -mindepth 1 \( -type f -o -type d \) | while IFS= read -r src; do
    rel="${src#"$latest_backup"/}"
    dst="$HOME/$rel"
    run mkdir -p "$(dirname "$dst")"
    run mv "$src" "$dst"
  done
fi

log_step "Done"
log_warn "Packages installed by install.sh were NOT removed. To clean up:"
log_dim "  macOS: brew bundle cleanup --file=$DOT_ROOT/Brewfile --force"
log_dim "  Linux: cat $DOT_ROOT/packages/apt.txt"
