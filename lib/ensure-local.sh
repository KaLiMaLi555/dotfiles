# shellcheck shell=bash
# Make sure the per-machine local-overlay files exist as empty stubs.
# Never overwrite — only seed if missing.

ensure_local_files() {
  local files=(
    "$HOME/.zshrc.local"
    "$HOME/.gitconfig.local"
  )
  for f in "${files[@]}"; do
    if [ ! -e "$f" ]; then
      run touch "$f"
      run chmod 600 "$f"
      log_ok "seeded empty $f"
      log_dim "   fill in from examples/$(basename "$f" | sed 's/^\.//')"
    fi
  done
}
