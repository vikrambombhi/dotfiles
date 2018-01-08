#/bin/bash

# Varibles
dir=$(pwd)

echo "Copying bspwm config"
mkdir -p ~/.config/bspwm
ln -s $dir/bspwm/bspwmrc ~/.config/bspwm --backup=existing

echo "Copying neovim config"
mkdir -p ~/.config/nvim
ln -s $dir/nvim/init.vim ~/.config/nvim --backup=existing

echo "Copying polybar config"
mkdir -p ~/.config/polybar
ln -s $dir/polybar/config ~/.config/polybar --backup=existing

echo "Copying sxhkd config"
mkdir -p ~/.config/sxhkd
ln -s $dir/sxhkd/sxhkdrc ~/.config/sxhkd --backup=existing
