.PHONY: adopt audit bootstrap check doctor install list-backups restore-backup secret-scan brew-dump

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

list-backups:
	./scripts/list-backups.sh

restore-backup:
	@test -n "$(BACKUP)" || (echo "usage: make restore-backup BACKUP=20260523-211830" >&2; exit 2)
	./scripts/restore-backup.sh "$(BACKUP)"

secret-scan:
	./scripts/secret-scan.sh

check: audit secret-scan
	sh -n bootstrap.sh install.sh scripts/audit.sh scripts/doctor.sh scripts/adopt-file.sh scripts/list-backups.sh scripts/restore-backup.sh scripts/secret-scan.sh
	zsh -n .zshrc .local/aws_functions.sh .local/misc_functions.sh .local/my_aliases.sh

brew-dump:
	brew bundle dump --file "$$HOME/.config/homebrew/Brewfile" --force
	cp "$$HOME/.config/homebrew/Brewfile" "$$HOME/.dotfiles/.config/homebrew/Brewfile"
