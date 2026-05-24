.PHONY: audit check install secret-scan brew-dump

install:
	./install.sh

audit:
	./scripts/audit.sh

secret-scan:
	./scripts/secret-scan.sh

check: audit secret-scan
	sh -n install.sh scripts/audit.sh scripts/secret-scan.sh
	zsh -n .zshrc .local/aws_functions.sh .local/misc_functions.sh .local/my_aliases.sh

brew-dump:
	brew bundle dump --file "$$HOME/.config/homebrew/Brewfile" --force
	cp "$$HOME/.config/homebrew/Brewfile" "$$HOME/.dotfiles/.config/homebrew/Brewfile"
