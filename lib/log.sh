# shellcheck shell=bash
# Logging helpers. Source from install.sh.

RED='\033[0;31m'; GRN='\033[0;32m'; YLW='\033[0;33m'; BLU='\033[0;34m'; DIM='\033[2m'; CLR='\033[0m'

log_info()  { printf "${BLU}▸${CLR} %s\n" "$*"; }
log_ok()    { printf "${GRN}✔${CLR} %s\n" "$*"; }
log_warn()  { printf "${YLW}⚠${CLR} %s\n" "$*" >&2; }
log_err()   { printf "${RED}✘${CLR} %s\n" "$*" >&2; }
log_step()  { printf "\n${BLU}━━ %s ━━${CLR}\n" "$*"; }
log_dim()   { printf "${DIM}  %s${CLR}\n" "$*"; }
log_dry()   { printf "${YLW}[dry-run]${CLR} %s\n" "$*"; }

die() { log_err "$*"; exit 1; }
