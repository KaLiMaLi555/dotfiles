# shellcheck shell=bash
# Expand a profile's tools.txt (resolving @include base.inc) into a flat list.

expand_profile() {
  local profile="$1"
  local profile_dir="$DOT_ROOT/profiles/$profile"
  [ -d "$profile_dir" ] || die "Unknown profile: $profile"
  local tools_file="$profile_dir/tools.txt"
  [ -f "$tools_file" ] || die "Missing $tools_file"

  local -a tools=()
  while IFS= read -r line; do
    line="${line%%#*}"
    line="$(echo "$line" | xargs)"
    [ -z "$line" ] && continue
    if [[ "$line" =~ ^@include[[:space:]]+(.+)$ ]]; then
      local inc="${BASH_REMATCH[1]}"
      local inc_path="$DOT_ROOT/profiles/$inc"
      [ -f "$inc_path" ] || die "Missing include: $inc_path"
      while IFS= read -r sub; do
        sub="${sub%%#*}"
        sub="$(echo "$sub" | xargs)"
        [ -n "$sub" ] && tools+=("$sub")
      done < "$inc_path"
    else
      tools+=("$line")
    fi
  done < "$tools_file"

  for t in "${tools[@]}"; do
    [ -d "$DOT_ROOT/stow/$t" ] || die "Profile '$profile' lists '$t' but stow/$t does not exist"
  done

  printf "%s\n" "${tools[@]}" | awk '!seen[$0]++'
}
