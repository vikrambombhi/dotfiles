#/bin/bash

# Varibles
dir=$(pwd)

echo "Copying neovim config"
mkdir -p ~/.config/nvim
ln -s $dir/nvim/init.vim ~/.config/nvim --backup=simple

echo "Copy libinput config"
ln -s $dir/libinput-gestures.conf ~/.config/libinput-gestures.conf --backup=simple

echo "Using ssh for git by default"
ln -s $dir/.gitconfig ~/.gitconfig --backup=simple
