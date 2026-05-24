#!/bin/sh
set -eu

if ! command -v shellcheck >/dev/null 2>&1; then
  printf 'shellcheck not installed; skipping\n'
  exit 0
fi

shellcheck \
  bootstrap.sh \
  install.sh \
  scripts/adopt-file.sh \
  scripts/apply-macos-defaults.sh \
  scripts/audit.sh \
  scripts/doctor.sh \
  scripts/list-backups.sh \
  scripts/restore-backup.sh \
  scripts/secret-scan.sh
