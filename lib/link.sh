# shellcheck shell=bash
# Wrap stow with pre-flight backup of conflicting LEAF files.

# Only back up real files / symlinks that would collide with a stow-linked target.
# Never move directories — stow folds them automatically.
backup_collisions() {
  local pkg="$1"
  local pkg_root="$DOT_ROOT/stow/$pkg"
  [ -d "$pkg_root" ] || return 0

  local ts="$DOT_ROOT/.backup/$(date +%Y%m%d-%H%M%S)"
  # Walk only files and symlinks under the package
  find "$pkg_root" \( -type f -o -type l \) -not -path '*/.git/*' | while IFS= read -r src; do
    local rel="${src#"$pkg_root"/}"
    local dst="$HOME/$rel"
    [ -e "$dst" ] || [ -L "$dst" ] || continue

    if [ -L "$dst" ]; then
      local target
      target="$(readlink "$dst")"
      case "$target" in
        "$DOT_ROOT"/*|*/dotfiles/*) continue ;;  # already a repo symlink
      esac
    fi

    run mkdir -p "$(dirname "$ts/$rel")"
    run mv "$dst" "$ts/$rel"
    log_ok "backed up $dst → $ts/$rel"
  done
}

stow_link() {
  local pkg="$1"
  backup_collisions "$pkg"
  run stow --dir="$DOT_ROOT/stow" --target="$HOME" --restow --no-folding "$pkg"
}

stow_unlink() {
  local pkg="$1"
  run stow --dir="$DOT_ROOT/stow" --target="$HOME" --delete "$pkg" || true
}
