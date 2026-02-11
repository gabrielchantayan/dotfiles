#!/bin/zsh

# Script to add, commit, and push config items to the git repo

COMMIT_MSG="${1:-Update dotfiles}"

echo "Adding items to git"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/nvim/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/commands/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.claude/skills/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/command/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/skills/
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/AGENTS.md
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/opencode/opencode.json
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.zshrc
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.bashrc
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/update-dotfiles.sh   # Meta, I know.
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/README.md
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME add ~/.config/kitty/kitty.conf

echo "Committing changes"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME commit -m "$COMMIT_MSG"

echo "Pushing to remote"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME push

echo "Done"
