#/bin/bash

# Varibles
dir=$(pwd)

# Create config and dev folders
echo "Creating config folder"
mkdir ~/.config
echo "Creating dev folder using GOPATH structure"
mkdir -p ~/dev/src/github.com

# Install Golang if not already not installed
if [ ! $(bash -c "command -v go") ]; then
  echo "Golang not found installing it now"
  sudo apt install -y golang-go

  echo "" >> ~/.bashrc
  echo "# Set GOPATH to custom path" >> ~/.bashrc
  echo "export GOPATH=~/dev" >> ~/.bashrc
fi

# Install neovim not already installed
if [ ! $(bash -c "command -v nvim") ]; then
  # Install neovim
  echo "Adding neovim PPA"
  sudo apt-add-repository -y ppa:neovim-ppa/stable
  sudo apt update
  echo "Installing neovim"
  sudo apt install -y neovim
  echo "Installing python prerequisites for neovim"
  sudo apt install -y python-dev python-pip python3-dev python3-pip

  # Install vimplug
  echo "Installing vimplug for neovim"
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


  # Set neovim config
  echo "Setting up neovim, dont forget to install packages after this"
  mkdir ~/.config/nvim
  ln -s $dir/nvim.vim ~/.config/nvim/init.vim --backup=simple
fi

# Install libintput-geastures for trackpad geastures
if [ ! $(bash -c "command -v libinput-gestures") ]; then
  # Install dependencies
  sudo apt install -y xdotool wmctrl libinput-tools

  echo "Setting up trackpad gestures"
  ln -s $dir/libinput-gestures.conf ~/.config/libinput-gestures.conf --backup=simple

  echo "Download libintput-gestures for trackpad gestures"
  go get github.com/bulletmark/libinput-gestures
  cd /home/vikram/dev/src/github.com/bulletmark/libinput-gestures
  sudo ./libinput-gestures-setup install

  echo "Adding user to input group"
  sudo gpasswd -a $USER input


  echo "Starting trackpad gestures service"
  libinput-gestures-setup autostart

  echo "Restart computer for geastures to take effect"
  echo "To stop geastures from autostarting use command 'libinput-gestures-setup autostop' "
fi

echo "Setting up git config"
ln -s $dir/gitconfig ~/.gitconfig --backup=simple
