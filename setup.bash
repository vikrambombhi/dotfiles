#/bin/bash

# Varibles
dir=$(pwd)

# Create config and dev folders
echo "Creating dev folder"
mkdir -p ~/dev/

# Required dependencies
# - tmux
# - nvim
# - ripgrep
if [ ! $(bash -c "command -v tmux") ]; then
	echo "Error: tmux should already be installed" >> /dev/stderr
	exit
fi
if [ ! $(bash -c "command -v nvim") ]; then
	echo "Error: nvim should already be installed" >> /dev/stderr
	exit
fi
if [ ! $(bash -c "command -v rg") ]; then
	echo "Error: ripgrep should already be installed" >> /dev/stderr
	exit
fi

if [ ! -f ~/.tmux/plugins/tpm/tpm ]; then
	echo "Installing tpm"
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	echo "Remember to press prefix + I (capital i, as in Install) to install plugins"
fi


# Set configs
if [ ! -f ~/.config ]; then
	echo "Linking configs"
	ln -s $dir/config/ ~/.config
fi


echo "Setting up git config"
ln -s $dir/gitconfig ~/.gitconfig

if grep -Fxq "source $dir/dev.sh" "$HOME/.bashrc"; then
    echo "Dev util already installed"
else
    echo "Setting up dev util"
    echo "You will need to source ~/.bashrc after"
    echo "source $dir/dev.sh" >> ~/.bashrc
fi
