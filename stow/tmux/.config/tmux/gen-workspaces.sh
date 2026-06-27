#!/bin/bash
# ──────────────────────────────────────────────
# gen-workspaces.sh
# Scans workspaces/*.conf, reads header metadata,
# and generates workspaces.conf with keybindings
# for all enabled workspaces.
# ──────────────────────────────────────────────

TMUX_DIR="$HOME/.config/tmux"
WORKSPACES_DIR="$TMUX_DIR/workspaces"
OUTPUT="$TMUX_DIR/workspaces.conf"

cat > "$OUTPUT" << 'HEADER'
# ──────────────────────────────────────────────
# AUTO-GENERATED — do not edit manually
# Run gen-workspaces.sh or prefix+r to regenerate
# ──────────────────────────────────────────────
HEADER

for conf in "$WORKSPACES_DIR"/*.conf; do
  [ -f "$conf" ] || continue

  name=""
  keybind=""
  enabled=""

  # Parse header comments
  while IFS= read -r line; do
    case "$line" in
      "# name: "*)    name="${line#\# name: }" ;;
      "# keybind: "*) keybind="${line#\# keybind: }" ;;
      "# enabled: "*) enabled="${line#\# enabled: }" ;;
      "#"*)           continue ;;
      *)              break ;;
    esac
  done < "$conf"

  if [ "$enabled" != "true" ]; then
    echo "# [disabled] $name ($keybind) — $(basename "$conf")" >> "$OUTPUT"
    continue
  fi

  if [ -z "$keybind" ]; then
    echo "# [no keybind] $name — $(basename "$conf")" >> "$OUTPUT"
    continue
  fi

  echo "bind $keybind source-file $conf \\; display \"$name loaded\"" >> "$OUTPUT"
done
