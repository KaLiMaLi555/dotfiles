# shellcheck shell=bash
# Render templates/*.tmpl into stow/ using profile env. Mac-personal-only by default.

render_templates() {
  local profile="$1"
  [ "$profile" = "mac-personal" ] || return 0

  local env_file="$DOT_ROOT/profiles/$profile/env"
  [ -f "$env_file" ] || return 0
  # shellcheck disable=SC1090
  set -a; . "$env_file"; set +a

  local dev_tmpl="$DOT_ROOT/templates/tmux-workspaces-dev.conf.tmpl"
  local dev_out="$DOT_ROOT/stow/tmux/.config/tmux/workspaces/dev.conf"
  if [ -f "$dev_tmpl" ]; then
    if [ "${DRY_RUN:-0}" = "1" ]; then
      log_dry "envsubst < $dev_tmpl > $dev_out"
    else
      WORK_DIR="${WORK_DIR:-$HOME/work}" envsubst '$WORK_DIR' < "$dev_tmpl" > "$dev_out"
      log_ok "rendered tmux dev.conf (WORK_DIR=$WORK_DIR)"
    fi
  fi
}
