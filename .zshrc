HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt appendhistory

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Users/toddwalters/.local/bin:$PATH"

export GREP_OPTIONS='--color=auto'

for file in $HOME/.local/include/*;
  do source $file
done

eval "$(pyenv init -)"
eval "$(fnm env --use-on-cd)"
eval "$(zoxide init zsh)"
eval "$(mcfly init zsh)"
eval $(thefuck --alias fuck)
eval "$(starship init zsh)"

PROMPT="${PROMPT}"$'\n'

fastfetch

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

source /Users/toddwalters/.config/broot/launcher/bash/br
