#!/bin/sh
set -eu

DOTFILES_DIR=$(cd -- "$(dirname -- "$0")/.." && pwd)
OSX_SCRIPT="$DOTFILES_DIR/.osx"
DRY_RUN=0
NO_RESTART=0
YES=0

usage() {
  cat <<'USAGE'
Usage: ./scripts/apply-macos-defaults.sh [--dry-run] [--no-restart] [--yes]

  --dry-run     Show the command that would run.
  --no-restart  Pass --no-restart to .osx.
  --yes         Apply without an interactive confirmation prompt.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --no-restart) NO_RESTART=1 ;;
    --yes) YES=1 ;;
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

if [ ! -x "$OSX_SCRIPT" ]; then
  printf 'macOS defaults script is not executable: %s\n' "$OSX_SCRIPT" >&2
  exit 1
fi

set -- "$OSX_SCRIPT"
if [ "$NO_RESTART" -eq 1 ]; then
  set -- "$@" --no-restart
fi

if [ "$DRY_RUN" -eq 1 ]; then
  printf 'would run:'
  for arg in "$@"; do
    printf ' %s' "$arg"
  done
  printf '\n'
  exit 0
fi

if [ "$YES" -ne 1 ]; then
  printf 'This will apply macOS defaults from %s.\n' "$OSX_SCRIPT"
  printf 'Some settings may require sudo privileges, restart apps, or change system behavior.\n'
  printf 'Continue? [y/N] '
  read -r answer
  case "$answer" in
    y|Y|yes|YES) ;;
    *)
      printf 'cancelled\n'
      exit 1
      ;;
  esac
fi

exec "$@"
