# Dotfiles

Personal macOS dotfiles and selected application config for `toddwalters`.

This repo tracks human-authored configuration only. It intentionally excludes
credentials, auth tokens, command history, caches, databases, generated app
state, and large tool directories.

## Tracked

- Shell and editor basics: `.zshrc`, `.vimrc`, `.condarc`
- Shell modules: `.local/aws_functions.sh`, `.local/misc_functions.sh`, `.local/my_aliases.sh`
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
- Caches and large state: `.cache`, most of `.local`, `.npm`, `.ollama`, `.tart`, `.vscode`
- Histories: `.zsh_history`, `.python_history`, `.lesshst`, `.viminfo`
- Machine-local overrides: `.zshrc.local`, `.gitconfig.local`, `.config/ghostty/config.local`

## Daily Use

Start by syncing the repository and checking links:

```sh
cd "$HOME/.dotfiles"
git pull
make audit
```

On a fresh machine, clone the repo to `~/.dotfiles`, then run:

```sh
cd "$HOME/.dotfiles"
make bootstrap
```

To install Homebrew first or install packages from the Brewfile:

```sh
./bootstrap.sh --install-homebrew --brew-bundle
```

After changing a managed config file, check the repo and commit normally:

```sh
cd "$HOME/.dotfiles"
git status
make check
git add <files>
git commit -m "Update dotfiles"
git push
```

When an application writes a useful change to a managed file, adopt it back:

```sh
make adopt FILE=.config/starship.toml
make check
```

## Install

Run:

```sh
make install
```

The installer creates parent directories as needed and symlinks tracked files
into `$HOME`. If a destination already exists and is not the desired symlink, it
is moved aside to a timestamped backup before the symlink is created.

Preview changes without writing:

```sh
./install.sh --dry-run
```

Managed files are listed in `managed-files.txt`. The audit script uses the same
manifest, so adding a new managed file is a two-step process:

1. Add the file to the repo.
2. Add its relative path to `managed-files.txt`.

## Local Overrides

Use local override files for machine-specific choices. They are ignored by git:

- `~/.zshrc.local`
- `~/.gitconfig.local`
- `~/.config/ghostty/config.local`

Examples live in:

- `.zshrc.local.example`
- `.gitconfig.local.example`
- `.config/ghostty/config.local.example`

`.zshrc` automatically sources `~/.zshrc.local` when it exists.

## Backups And Restore

The installer moves replaced files into timestamped directories under
`~/.dotfiles-backup`.

List backups:

```sh
make list-backups
```

Preview restoring a backup:

```sh
./scripts/restore-backup.sh 20260523-211830 --dry-run
```

Restore a backup:

```sh
make restore-backup BACKUP=20260523-211830
```

## Homebrew

Refresh the Brewfile from the current machine with:

```sh
make brew-dump
```

Install packages on a new machine with:

```sh
brew bundle --file "$HOME/.config/homebrew/Brewfile"
```

## macOS Defaults

The `.osx` script changes macOS system preferences and can run commands that
need sudo privileges. Use the wrapper so applying it is explicit:

```sh
./scripts/apply-macos-defaults.sh --dry-run --no-restart
./scripts/apply-macos-defaults.sh --no-restart
```

To skip the confirmation prompt:

```sh
./scripts/apply-macos-defaults.sh --yes
```

## Checks

Run all checks:

```sh
make check
```

This verifies symlinks, runs a focused secret-pattern scan, and syntax-checks
the shell scripts. When ShellCheck is installed, it also runs ShellCheck.

Check machine readiness:

```sh
make doctor
```

`doctor` reports required and recommended tools, verifies managed symlinks, and
shows which local override files are present.

## Adopt A File

Use `make adopt` when a tool writes a useful config change under `$HOME` and you
want this repo to manage it:

```sh
make adopt FILE=.config/ghostty/config
```

The adopt helper copies the home file into the repo, adds it to
`managed-files.txt` if needed, relinks managed files, and runs the symlink audit.

Avoid adopting credentials, generated state, history, caches, or large app data.

## CI

Pull requests and pushes to `main` run GitHub Actions checks on macOS:

- POSIX shell syntax checks
- zsh syntax checks
- ShellCheck
- focused secret scan
- install into an isolated `$HOME`
- symlink audit
- doctor check
- backup helper smoke tests
- macOS defaults dry-run smoke test
