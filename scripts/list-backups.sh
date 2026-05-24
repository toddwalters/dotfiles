#!/bin/sh
set -eu

BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}"

if [ ! -d "$BACKUP_ROOT" ]; then
  printf 'no backups found at %s\n' "$BACKUP_ROOT"
  exit 0
fi

find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d -print | sort | while IFS= read -r backup_dir; do
  count=$(find "$backup_dir" -type f -o -type l | wc -l | tr -d ' ')
  printf '%s\t%s item(s)\n' "$(basename "$backup_dir")" "$count"
done
