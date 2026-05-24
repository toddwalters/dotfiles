#!/bin/sh
set -eu

status=0

check_command() {
  name=$1
  required=${2:-optional}

  if command -v "$name" >/dev/null 2>&1; then
    printf 'ok %s\n' "$name"
    return
  fi

  if [ "$required" = "required" ]; then
    printf 'missing-required %s\n' "$name"
    status=1
  else
    printf 'missing-optional %s\n' "$name"
  fi
}

check_path() {
  path=$1
  label=$2

  if [ -e "$path" ]; then
    printf 'ok %s\n' "$label"
  else
    printf 'missing-optional %s\n' "$label"
  fi
}

printf 'Required tools\n'
check_command git required
check_command make required
check_command sh required
check_command zsh required

printf '\nRecommended tools\n'
check_command brew optional
check_command rg optional
check_command bat optional
check_command eza optional
check_command fastfetch optional
check_command fnm optional
check_command mcfly optional
check_command starship optional
check_command thefuck optional
check_command zoxide optional

printf '\nManaged config\n'
if ./scripts/audit.sh >/dev/null 2>&1; then
  printf 'ok symlinks\n'
else
  printf 'warning symlinks need attention; run make audit\n'
  status=1
fi

printf '\nLocal overrides\n'
check_path "$HOME/.zshrc.local" ".zshrc.local"
check_path "$HOME/.gitconfig.local" ".gitconfig.local"
check_path "$HOME/.config/ghostty/config.local" "ghostty config.local"

exit "$status"
