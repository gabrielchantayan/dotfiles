#!/bin/zsh

# Script to add, commit, and push config items to the git repo

COMMIT_MSG="${1:-Update dotfiles}"

echo "Adding items to git"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/nvim/

# AI Coding

## Claude
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/commands/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/skills/

## OpenCode
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/command/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/skills/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/AGENTS.md
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/opencode.json
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/plugin/


# Shells (unused)
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.zshrc
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.bashrc

# Misc
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/update-dotfiles.sh   # Meta, I know.
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/README.md

# Kitty
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/kitty/kitty.conf
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/kitty/kitty.app.png

# Fish
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/fish/config.fish
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/fish/functions/


echo "Committing changes"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m "$COMMIT_MSG"

echo "Pushing to remote"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME push

echo "Done"
