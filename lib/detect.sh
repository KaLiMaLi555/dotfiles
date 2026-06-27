# shellcheck shell=bash
# OS, profile, and shell detection.

detect_os() {
  case "$(uname -s)" in
    Darwin) echo "macos" ;;
    Linux)  echo "linux" ;;
    *)      die "Unsupported OS: $(uname -s)" ;;
  esac
}

detect_default_profile() {
  case "$(detect_os)" in
    macos) echo "mac-personal" ;;
    linux) echo "remote-vm" ;;
  esac
}

detect_package_manager() {
  if command -v brew >/dev/null 2>&1; then echo "brew"
  elif command -v apt-get >/dev/null 2>&1; then echo "apt"
  elif command -v dnf >/dev/null 2>&1; then echo "dnf"
  elif command -v pacman >/dev/null 2>&1; then echo "pacman"
  else echo "none"; fi
}
