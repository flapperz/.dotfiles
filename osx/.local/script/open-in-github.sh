#!/usr/bin/env bash

# Open the current repository in the browser
dir=$(tmux run "echo #{pane_start_path}")
cd $dir
url=$(git remote get-url origin) 

# fix me currently remote url can be git@github.com:flapperz/.dotfiles.git

# Check if the repository is on GitHub
if [[ $url == *"github.com"* ]]; then
  open $url
else
  echo "This repository is not hosted on GitHub"
fi