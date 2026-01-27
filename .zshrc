export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

mkcd() { mkdir -p "$1" && cd "$1"; } 

alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export PATH="$HOME/.local/bin:$PATH"

# bun completions
[ -s "/Users/gabe/.bun/_bun" ] && source "/Users/gabe/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Go
export PATH=$PATH:$HOME/go/bin

# cosa
export PATH="$HOME/Documents/Programming/cosa/bin:$PATH"

# aliases
## lg -> lazygit
alias lg='lazygit'

## update-dotfiles $1 -> sh ~/.config/update-dotfiles.sh $1
alias update-dotfiles='sh ~/.config/update-dotfiles.sh'
