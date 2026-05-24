#!/bin/sh
set -eu

BACKUP_ROOT="${DOTFILES_BACKUP_DIR:-$HOME/.dotfiles-backup}"

usage() {
  cat <<'USAGE'
Usage: ./scripts/restore-backup.sh <backup-id> [--dry-run]

Example:
  ./scripts/restore-backup.sh 20260523-211830 --dry-run
USAGE
}

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage >&2
  exit 2
fi

backup_id=$1
dry_run=0

if [ "${2:-}" = "--dry-run" ]; then
  dry_run=1
elif [ "$#" -eq 2 ]; then
  usage >&2
  exit 2
fi

case "$backup_id" in
  ''|.*|*/*|*..*)
    printf 'invalid backup id: %s\n' "$backup_id" >&2
    exit 2
    ;;
esac

backup_dir="$BACKUP_ROOT/$backup_id"
if [ ! -d "$backup_dir" ]; then
  printf 'backup not found: %s\n' "$backup_dir" >&2
  exit 1
fi

find "$backup_dir" -type f -o -type l | sort | while IFS= read -r backup_path; do
  relative_path=${backup_path#"$backup_dir"/}
  target_path="$HOME/$relative_path"

  if [ "$dry_run" -eq 1 ]; then
    printf 'restore %s -> %s\n' "$backup_path" "$target_path"
    continue
  fi

  mkdir -p "$(dirname -- "$target_path")"
  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    rm -f "$target_path"
  fi
  cp -P "$backup_path" "$target_path"
  printf 'restored %s\n' "$target_path"
done
