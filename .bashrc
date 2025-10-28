# Pyenv bullshit
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
. "$HOME/.cargo/env"

# Make directory and CD into it
mkcd() {
    mkdir -p $@ && cd $@;
}

# Alias for dotenvs
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

