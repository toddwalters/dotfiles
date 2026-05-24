.PHONY: adopt apply-macos-defaults audit bootstrap check doctor install list-backups restore-backup secret-scan shellcheck brew-dump

install:
	./install.sh

bootstrap:
	./bootstrap.sh

adopt:
	@test -n "$(FILE)" || (echo "usage: make adopt FILE=.config/starship.toml" >&2; exit 2)
	./scripts/adopt-file.sh "$(FILE)"

audit:
	./scripts/audit.sh

doctor:
	./scripts/doctor.sh

apply-macos-defaults:
	./scripts/apply-macos-defaults.sh

list-backups:
	./scripts/list-backups.sh

restore-backup:
	@test -n "$(BACKUP)" || (echo "usage: make restore-backup BACKUP=20260523-211830" >&2; exit 2)
	./scripts/restore-backup.sh "$(BACKUP)"

secret-scan:
	./scripts/secret-scan.sh

shellcheck:
	./scripts/shellcheck.sh

check: audit secret-scan
	sh -n bootstrap.sh install.sh scripts/adopt-file.sh scripts/apply-macos-defaults.sh scripts/audit.sh scripts/doctor.sh scripts/list-backups.sh scripts/restore-backup.sh scripts/secret-scan.sh scripts/shellcheck.sh
	zsh -n .zshrc .local/aws_functions.sh .local/misc_functions.sh .local/my_aliases.sh
	./scripts/shellcheck.sh

brew-dump:
	brew bundle dump --file "$$HOME/.config/homebrew/Brewfile" --force
	cp "$$HOME/.config/homebrew/Brewfile" "$$HOME/.dotfiles/.config/homebrew/Brewfile"
