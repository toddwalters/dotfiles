#!/bin/sh
set -eu

DOTFILES_DIR=$(cd -- "$(dirname -- "$0")" && pwd)
INSTALL_BREW=0
RUN_BREW_BUNDLE=0

usage() {
  cat <<'USAGE'
Usage: ./bootstrap.sh [--install-homebrew] [--brew-bundle]

  --install-homebrew  Install Homebrew when it is missing.
  --brew-bundle       Run brew bundle after dotfiles are installed.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --install-homebrew) INSTALL_BREW=1 ;;
    --brew-bundle) RUN_BREW_BUNDLE=1 ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'unknown option: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if ! command -v git >/dev/null 2>&1; then
  printf 'git is required before bootstrapping dotfiles\n' >&2
  exit 1
fi

if ! command -v brew >/dev/null 2>&1; then
  if [ "$INSTALL_BREW" -eq 1 ]; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    printf 'warning: Homebrew is not installed; pass --install-homebrew to install it\n' >&2
  fi
fi

"$DOTFILES_DIR/install.sh"
"$DOTFILES_DIR/scripts/doctor.sh"

if [ "$RUN_BREW_BUNDLE" -eq 1 ]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf 'brew bundle requested, but brew is not available\n' >&2
    exit 1
  fi
  brew bundle --file "$HOME/.config/homebrew/Brewfile"
fi
