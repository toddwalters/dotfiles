# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:/Volumes/s990pro/Users/toddwalters/.local/bin:$PATH"
export DOCKER_CONFIG=$HOME/.docker-nokeychain

setopt appendhistory

export GREP_OPTIONS='--color=auto'
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

for file in $HOME/.local/include/*;
  do source $file
done

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
