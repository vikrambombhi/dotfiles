#/bin/bash

# Varibles
dir=$(pwd)

echo "Copying bspwm config"
mkdir -p ~/.config/bspwm
ln -s $dir/bspwm/bspwmrc ~/.config/bspwm --backup=numbered

echo "Copying neovim config"
mkdir -p ~/.config/nvim
mkdir -p ~/.config/nvim/.backup
mkdir -p ~/.config/nvim/.swap
mkdir -p ~/.config/nvim/.undo
ln -s $dir/nvim/init.vim ~/.config/nvim --backup=numbered

echo "Copying polybar config"
mkdir -p ~/.config/polybar
ln -s $dir/polybar/config ~/.config/polybar --backup=numbered

echo "Copying sxhkd config"
mkdir -p ~/.config/sxhkd
ln -s $dir/sxhkd/sxhkdrc ~/.config/sxhkd --backup=numbered
