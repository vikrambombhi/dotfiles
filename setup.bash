#/bin/bash

# Varibles
dir=$(pwd)

echo "Copying neovim config"
mkdir -p ~/.config/nvim
ln -s $dir/nvim/init.vim ~/.config/nvim --backup=numbered
