HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory
typeset -U path

path=(
  /opt/homebrew/bin
  /opt/homebrew/sbin
  "$HOME/.local/bin"
  $path
)

export DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker-nokeychain}"
export GREP_OPTIONS='--color=auto'

for file in "$HOME"/.local/include/*.sh(N); do
  [ -r "$file" ] && source "$file"
done

for file in "$HOME"/.local/*.sh(N); do
  [ -r "$file" ] && source "$file"
done

if command -v fnm >/dev/null 2>&1; then
  eval "$(fnm env --use-on-cd)"
elif [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
  export NVM_DIR="$HOME/.nvm"
  source "/opt/homebrew/opt/nvm/nvm.sh"
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
fi

command -v zoxide >/dev/null 2>&1 && eval "$(zoxide init zsh)"
command -v mcfly >/dev/null 2>&1 && eval "$(mcfly init zsh)"
command -v thefuck >/dev/null 2>&1 && eval "$(thefuck --alias fuck)"
command -v starship >/dev/null 2>&1 && eval "$(starship init zsh)"

PROMPT="${PROMPT}"$'\n'

command -v fastfetch >/dev/null 2>&1 && fastfetch

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

fpath+=~/.zfunc
autoload -Uz compinit && compinit

[ -r "$HOME/.config/broot/launcher/bash/br" ] && source "$HOME/.config/broot/launcher/bash/br"
[ -r "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
