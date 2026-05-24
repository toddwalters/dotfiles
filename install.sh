#!/bin/sh
set -eu

DOTFILES_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
HOME_DIR=${HOME:-/Users/toddwalters}
BACKUP_DIR="$HOME_DIR/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

link_file() {
  source_path=$1
  target_path=$2

  mkdir -p "$(dirname -- "$target_path")"

  if [ -L "$target_path" ]; then
    current_target=$(readlink "$target_path")
    if [ "$current_target" = "$source_path" ]; then
      printf 'ok %s\n' "$target_path"
      return
    fi
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    mkdir -p "$BACKUP_DIR/$(dirname -- "${target_path#$HOME_DIR/}")"
    mv "$target_path" "$BACKUP_DIR/${target_path#$HOME_DIR/}"
    printf 'backup %s\n' "$target_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'link %s -> %s\n' "$target_path" "$source_path"
}

link_file "$DOTFILES_DIR/.condarc" "$HOME_DIR/.condarc"
link_file "$DOTFILES_DIR/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$DOTFILES_DIR/.gitignore" "$HOME_DIR/.gitignore"
link_file "$DOTFILES_DIR/.osx" "$HOME_DIR/.osx"
link_file "$DOTFILES_DIR/.vimrc" "$HOME_DIR/.vimrc"
link_file "$DOTFILES_DIR/.zshrc" "$HOME_DIR/.zshrc"
link_file "$DOTFILES_DIR/.config/atuin/config.toml" "$HOME_DIR/.config/atuin/config.toml"
link_file "$DOTFILES_DIR/.config/btop/btop.conf" "$HOME_DIR/.config/btop/btop.conf"
link_file "$DOTFILES_DIR/.config/fastfetch/config.jsonc" "$HOME_DIR/.config/fastfetch/config.jsonc"
link_file "$DOTFILES_DIR/.config/gh/config.yml" "$HOME_DIR/.config/gh/config.yml"
link_file "$DOTFILES_DIR/.config/ghostty/config" "$HOME_DIR/.config/ghostty/config"
link_file "$DOTFILES_DIR/.config/git/ignore" "$HOME_DIR/.config/git/ignore"
link_file "$DOTFILES_DIR/.config/homebrew/Brewfile" "$HOME_DIR/.config/homebrew/Brewfile"
link_file "$DOTFILES_DIR/.config/powershell/profile.ps1" "$HOME_DIR/.config/powershell/profile.ps1"
link_file "$DOTFILES_DIR/.config/starship.toml" "$HOME_DIR/.config/starship.toml"
