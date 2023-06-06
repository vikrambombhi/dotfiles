#/bin/bash

# Varibles
dir=$(pwd)

# Create config and dev folders
echo "Creating config folder"
mkdir -p ~/.config
echo "Creating dev folder"
mkdir -p ~/dev/


# Install tmux not already installed
if [ ! $(bash -c "command -v tmux") ]; then
	echo "Error: tmux should already be installed" >> /dev/stderr
	exit
fi

if [ ! -f ~/.tmux/plugins/tpm/tpm ]; then
	echo "Installing tpm"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "Remember to press prefix + I (capital i, as in Install) to install plugins"
fi

if [ ! -f ~/.tmux.conf ]; then
	echo "Linking up tmux config"
	ln -s $dir/tmux.conf ~/.tmux.conf
fi


# Install neovim not already installed
if [ ! $(bash -c "command -v nvim") ]; then
	echo "Error: nvim should already be installed" >> /dev/stderr
	exit
fi

# Install vimplug
echo "Installing vimplug for neovim"
curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Set neovim config
if [ ! -f ~/.config/nvim/init.vim ]; then
	echo "Linking neovim config, dont forget to install packages after this"
	ln -s $dir/nvim/ ~/.config/nvim
fi


echo "Setting up git config"
ln -s $dir/gitconfig ~/.gitconfig

echo "Setting up alacrity"
mkdir -p ~/.config/alacritty
ln -s $dir/alacritty.yml ~/.config/alacritty/alacritty.yml
