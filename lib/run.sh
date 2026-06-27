# shellcheck shell=bash
# Run a command, honoring DRY_RUN=1.

run() {
  if [ "${DRY_RUN:-0}" = "1" ]; then
    log_dry "$*"
  else
    log_dim "+ $*"
    "$@"
  fi
}
