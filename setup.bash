#/bin/bash

# Varibles
dir=$(pwd)

echo "Creating config folder"
mkdir ~/.config
echo "Creating dev folder using GOPATH structure"
mkdir -p ~/dev/src/github.com

echo "Adding neovim PPA"
sudo apt-add-repository -y ppa:neovim-ppa/stable
sudo apt update
echo "Installing neovim"
sudo apt install neovim
echo "Installing python prerequisites for neovim"
sudo apt install python-dev python-pip python3-dev python3-pip
echo "Installing vim plug for neovim"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
echo "Setting up neovim, dont forget to install packages after this"
mkdir ~/.config/nvim
ln -s $dir/nvim.vim ~/.config/nvim/init.vim --backup=simple

echo "Installing libintput-gestures for trackpad gestures"
git clone https://github.com/bulletmark/libinput-gestures.git ~/dev/src/github.com/
.~/dev/src/github.com/bulletmark/libinput-gestures-setup install
echo "Setting up trackpad gestures"
ln -s $dir/libinput-gestures.conf ~/.config/libinput-gestures.conf --backup=simple
echo "Starting trackpad gestures service"
libinput-gestures-setup autostart
libinput-gestures-setup start
echo "To stop geastures from autostarting use command 'libinput-gestures-setup autostop' "

echo "Setting up git config"
ln -s $dir/gitconfig ~/.gitconfig --backup=simple
