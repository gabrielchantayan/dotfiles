#!/bin/zsh

# Bash script to add config items to the git repo

echo "Adding items to the git add"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/nvim/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/commands/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/skills/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.zshrc
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/add-items.sh
echo "Done"
