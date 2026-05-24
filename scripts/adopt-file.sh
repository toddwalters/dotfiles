#!/bin/sh
set -eu

DOTFILES_DIR=$(cd -- "$(dirname -- "$0")/.." && pwd)
HOME_DIR=${HOME:-/Users/toddwalters}
MANIFEST="$DOTFILES_DIR/managed-files.txt"

usage() {
  cat <<'USAGE'
Usage: ./scripts/adopt-file.sh <relative-path>

Examples:
  ./scripts/adopt-file.sh .config/starship.toml
  ./scripts/adopt-file.sh .zshrc
USAGE
}

if [ "$#" -ne 1 ]; then
  usage >&2
  exit 2
fi

relative_path=${1#"$HOME_DIR"/}
relative_path=${relative_path#./}

case "$relative_path" in
  ''|/*|..|../*|*/../*)
    printf 'path must be inside HOME and relative: %s\n' "$1" >&2
    exit 2
    ;;
esac

source_path="$HOME_DIR/$relative_path"
target_path="$DOTFILES_DIR/$relative_path"

if [ ! -e "$source_path" ]; then
  printf 'home file does not exist: %s\n' "$source_path" >&2
  exit 1
fi

if [ -L "$source_path" ]; then
  link_target=$(readlink "$source_path")
  if [ "$link_target" = "$target_path" ]; then
    printf 'already-managed %s\n' "$relative_path"
  else
    printf 'refusing to adopt symlink with different target: %s -> %s\n' "$source_path" "$link_target" >&2
    exit 1
  fi
else
  mkdir -p "$(dirname -- "$target_path")"
  cp "$source_path" "$target_path"
  printf 'adopted %s -> %s\n' "$source_path" "$target_path"
fi

if ! grep -Fxq "$relative_path" "$MANIFEST"; then
  printf '%s\n' "$relative_path" >> "$MANIFEST"
  printf 'manifest-added %s\n' "$relative_path"
else
  printf 'manifest-ok %s\n' "$relative_path"
fi

./install.sh
./scripts/audit.sh
