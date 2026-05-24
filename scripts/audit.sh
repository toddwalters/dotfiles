#!/bin/sh
set -eu

DOTFILES_DIR=$(cd -- "$(dirname -- "$0")/.." && pwd)
HOME_DIR=${HOME:-/Users/toddwalters}
MANIFEST="$DOTFILES_DIR/managed-files.txt"
status=0

while IFS= read -r relative_path || [ -n "$relative_path" ]; do
  case "$relative_path" in
    ''|'#'*) continue ;;
  esac

  source_path="$DOTFILES_DIR/$relative_path"
  target_path="$HOME_DIR/$relative_path"

  if [ ! -e "$source_path" ]; then
    printf 'missing-source %s\n' "$relative_path"
    status=1
    continue
  fi

  if [ ! -L "$target_path" ]; then
    if [ -e "$target_path" ]; then
      printf 'not-symlink %s\n' "$relative_path"
    else
      printf 'missing-target %s\n' "$relative_path"
    fi
    status=1
    continue
  fi

  link_target=$(readlink "$target_path")
  if [ "$link_target" != "$source_path" ]; then
    printf 'wrong-target %s -> %s\n' "$relative_path" "$link_target"
    status=1
    continue
  fi

  printf 'ok %s\n' "$relative_path"
done < "$MANIFEST"

exit "$status"
