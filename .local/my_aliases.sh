# Apple system related
#
alias turnonbt='blueutil --power 1'
alias turnoffbt='blueutil --power 0'
# Show/hide hidden files in Finder
alias show='defaults write com.apple.finder AppleShowAllFiles YES;killall Finder /System/Library/CoreServices/Finder.app'
alias hide='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'
# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

# Git
#
alias gpom='git pull origin master'
alias gmo='git merge origin'
alias gmu='git merge --no-commit upstream/main'
alias gc='git checkout'
alias gs='git status'
alias gcm='git commit -m'
alias ga='git add'
alias gb='git branch'
alias gf='git fetch'
alias gfu='git fetch upstream --verbose'
alias glu='git log --graph --oneline HEAD..upstream/main'
alias gp='git pull'
alias gr='git restore'
alias gu='git fetch upstream --verbose; git log --graph --oneline HEAD..upstream/main; git merge --no-commit upstream/main'
alias push='git push origin'
alias pull='git pull origin'
alias stash='git stash'
alias sapply='git stash apply'

# Docker
#
alias di='docker images list'
alias dcp='docker container prune -f'
alias di='docker images'
alias dpa='docker ps -a'
alias dp='docker pull'
alias drf='docker rmi -f'
alias dsp='docker system prune -f'
alias azl='/Applications/Microsoft\ Edge\ Dev.app/Contents/MacOS/Microsoft\ Edge\ Dev --profile-directory="Profile 4" &> /dev/null &; az login --use-device-code'
alias gcl='/Applications/Microsoft\ Edge\ Dev.app/Contents/MacOS/Microsoft\ Edge\ Dev --profile-directory="Profile 3" &> /dev/null &; gcloud auth login --no-launch-browser'
alias awl='/Applications/Microsoft\ Edge\ Dev.app/Contents/MacOS/Microsoft\ Edge\ Dev --profile-directory="Profile 1" https://waltodders.awsapps.com/start &> /dev/null &'

# Miscellaneous
#
alias actacond='conda activate .conda'
alias cat='bat'
alias dtz='date +"%Y-%m-%dT%H:%M:%S%z"'
alias ff='fastfetch'
alias funcs='cat ~/.local/include/*_functions.sh | egrep -B 1 function'
alias tf='terraform'
alias kcl='kubectl'
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias ls='/opt/homebrew/bin/eza'
alias lla='/opt/homebrew/bin/eza -lagGF --group-directories-first --icons'
alias la='ls -la'
alias tree='ls -T'  # directory tree
alias digs='dig +noall +answer'
alias powershell='/usr/local/bin/pwsh'
alias venv='python3 -m venv venv && . venv/bin/activate && python3 -m pip install -U pip'
alias weather='curl wttr.in'
# Recursively delete `.DS_Store` files
alias cleanup="find . -type f -name '*.DS_Store' -ls -delete"
# Lock the screen (when going AFK)
alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
