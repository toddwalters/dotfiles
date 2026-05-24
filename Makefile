.PHONY: adopt audit check doctor install secret-scan brew-dump

install:
	./install.sh

adopt:
	@test -n "$(FILE)" || (echo "usage: make adopt FILE=.config/starship.toml" >&2; exit 2)
	./scripts/adopt-file.sh "$(FILE)"

audit:
	./scripts/audit.sh

doctor:
	./scripts/doctor.sh

secret-scan:
	./scripts/secret-scan.sh

check: audit secret-scan
	sh -n install.sh scripts/audit.sh scripts/doctor.sh scripts/adopt-file.sh scripts/secret-scan.sh
	zsh -n .zshrc .local/aws_functions.sh .local/misc_functions.sh .local/my_aliases.sh

brew-dump:
	brew bundle dump --file "$$HOME/.config/homebrew/Brewfile" --force
	cp "$$HOME/.config/homebrew/Brewfile" "$$HOME/.dotfiles/.config/homebrew/Brewfile"
