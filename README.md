# Dotfiles

Personal macOS dotfiles and selected application config for `toddwalters`.

This repo tracks human-authored configuration only. It intentionally excludes
credentials, auth tokens, command history, caches, databases, generated app
state, and large tool directories.

## Tracked

- Shell and editor basics: `.zshrc`, `.vimrc`, `.condarc`
- Git config: `.gitconfig`, `.gitignore`, `.config/git/ignore`
- macOS defaults script: `.osx`
- Terminal and prompt config: `.config/ghostty/config`, `.config/starship.toml`
- CLI tools: Atuin, btop, fastfetch, GitHub CLI config, PowerShell profile
- Package inventory: `.config/homebrew/Brewfile`

## Not Tracked

Do not add these directly:

- Credentials: `.aws`, `.azure`, `.gnupg`, `.kube`, `.ssh`, `.creds`, `.vars`
- App auth/state: `.config/gh/hosts.yml`, `.config/gcloud`, `.docker`
- AI/tool state: `.claude`, `.claude.json`, `.codex`, `.agents`
- Caches and large state: `.cache`, `.local`, `.npm`, `.ollama`, `.tart`, `.vscode`
- Histories: `.zsh_history`, `.python_history`, `.lesshst`, `.viminfo`

## Install

Run:

```sh
./install.sh
```

The installer creates parent directories as needed and symlinks tracked files
into `$HOME`. If a destination already exists and is not the desired symlink, it
is moved aside to a timestamped backup before the symlink is created.

## Homebrew

Refresh the Brewfile from the current machine with:

```sh
brew bundle dump --file "$HOME/.config/homebrew/Brewfile" --force
cp "$HOME/.config/homebrew/Brewfile" "$HOME/.dotfiles/.config/homebrew/Brewfile"
```

Install packages on a new machine with:

```sh
brew bundle --file "$HOME/.config/homebrew/Brewfile"
```
