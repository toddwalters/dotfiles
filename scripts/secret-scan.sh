#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)

if ! command -v rg >/dev/null 2>&1; then
  printf 'ripgrep is required for secret scanning\n' >&2
  exit 1
fi

pattern="(ghp_[A-Za-z0-9_]{20,}|github_pat_[A-Za-z0-9_]+|AKIA[0-9A-Z]{16}|ASIA[0-9A-Z]{16}|sk-[A-Za-z0-9]{20,}|xox[baprs]-[A-Za-z0-9-]+|-----BEGIN [A-Z ]*PRIVATE KEY-----|(password|passwd|token|secret|api[_-]?key|access[_-]?key|private[_-]?key|authorization|bearer)[[:space:]]*[:=][[:space:]]*['\"][^'\"<>{} $]{8,})"

matches=$(rg -n -i "$pattern" "$DOTFILES_DIR" \
  --hidden \
  --glob '!README.md' \
  --glob '!Makefile' \
  --glob '!scripts/secret-scan.sh' \
  --glob '!.git/**' || true)

if [ -n "$matches" ]; then
  printf '%s\n' "$matches"
  exit 1
fi

printf 'ok secret-scan\n'
