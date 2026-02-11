# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# Cargo/Rust
fish_add_path $HOME/.cargo/bin

# pyenv
set -gx PYENV_ROOT $HOME/.pyenv
fish_add_path $PYENV_ROOT/bin
pyenv init - fish | source

# nvm
set -gx NVM_DIR $HOME/.nvm

# bun
set -gx BUN_INSTALL $HOME/.bun
fish_add_path $BUN_INSTALL/bin

# Go
fish_add_path $HOME/go/bin

# cosa
fish_add_path $HOME/Documents/Programming/cosa/bin

# local bin
fish_add_path $HOME/.local/bin

# Aliases
alias config '/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias lg lazygit
alias update-dotfiles 'sh ~/.config/update-dotfiles.sh'
alias clauded 'claude --dangerously-skip-permissions'

if status is-interactive
    set -l fish_art \
        '><>' \
        '><(°>' \
        '><((°>' \
        '><(((°>' \
        '><((((°>' \
        "><((('>)" \
        '><(((*>' \
        '><(((º>' \
        '><((((º>' \
        '><{{{°>' \
        '><{{{{º>' \
        '>°)))>>' \
        '>=((((°>' \
        '>><((°>' \
        '><((((•>' \
        '►<((((°>' \
        '}><((((°>' \
        '><((((¤>' \
        '><>>>>' \
        '>=(°>' \
        '><((((˚>' \
        '~><((((°>' \
        '~~><(((°>' \
        '¸¸.·><((((º>' \
        '.·´¯`·.><((((°>'
    set -g fish_greeting "  "$fish_art[(random 1 (count $fish_art))]

    # Minimal monochrome colors
    set -g fish_color_normal normal
    set -g fish_color_command normal
    set -g fish_color_keyword normal
    set -g fish_color_quote normal
    set -g fish_color_redirection normal
    set -g fish_color_end normal
    set -g fish_color_error normal --bold
    set -g fish_color_param normal
    set -g fish_color_comment 808080
    set -g fish_color_selection --background=3a3a3a
    set -g fish_color_operator normal
    set -g fish_color_escape normal
    set -g fish_color_autosuggestion 585858
    set -g fish_color_valid_path
    set -g fish_color_cwd normal
    set -g fish_color_user normal
    set -g fish_color_host normal

    set -g fish_pager_color_progress 808080
    set -g fish_pager_color_prefix normal --bold
    set -g fish_pager_color_completion normal
    set -g fish_pager_color_description 808080
    set -g fish_pager_color_selected_background --background=3a3a3a
end
