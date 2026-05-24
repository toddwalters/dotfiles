#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HOME_DIR=${HOME:-/Users/toddwalters}
BACKUP_DIR="$HOME_DIR/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
MANIFEST="$DOTFILES_DIR/managed-files.txt"
DRY_RUN=0
FORCE=0
ADOPT=0

usage() {
  cat <<'USAGE'
Usage: ./install.sh [--dry-run] [--force] [--adopt]

  --dry-run  Show planned changes without writing.
  --force    Explicitly replace existing files; backups are still kept.
  --adopt    Copy existing home files into the repo before linking.
USAGE
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --dry-run) DRY_RUN=1 ;;
    --force) FORCE=1 ;;
    --adopt) ADOPT=1 ;;
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

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf 'dry-run %s\n' "$*"
  else
    "$@"
  fi
}

link_file() {
  source_path=$1
  target_path=$2

  if [ ! -e "$source_path" ] && { [ "$ADOPT" -ne 1 ] || [ ! -e "$target_path" ]; }; then
    printf 'missing source: %s\n' "$source_path" >&2
    return 1
  fi

  if [ -L "$target_path" ]; then
    current_target=$(readlink "$target_path")
    if [ "$current_target" = "$source_path" ]; then
      printf 'ok %s\n' "$target_path"
      return
    fi
  fi

  run mkdir -p "$(dirname -- "$target_path")"

  if [ "$ADOPT" -eq 1 ] && [ -e "$target_path" ] && [ ! -L "$target_path" ]; then
    run mkdir -p "$(dirname -- "$source_path")"
    run cp "$target_path" "$source_path"
    printf 'adopt %s -> %s\n' "$target_path" "$source_path"
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    run mkdir -p "$BACKUP_DIR/$(dirname -- "${target_path#$HOME_DIR/}")"
    run mv "$target_path" "$BACKUP_DIR/${target_path#$HOME_DIR/}"
    printf 'backup %s\n' "$target_path"
  fi

  run ln -s "$source_path" "$target_path"
  printf 'link %s -> %s\n' "$target_path" "$source_path"
}

while IFS= read -r relative_path || [ -n "$relative_path" ]; do
  case "$relative_path" in
    ''|'#'*) continue ;;
  esac
  link_file "$DOTFILES_DIR/$relative_path" "$HOME_DIR/$relative_path"
done < "$MANIFEST"
