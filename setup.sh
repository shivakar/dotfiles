#!/usr/bin/env bash

if [ "${PWD}" != "$HOME/bin" ]; then
    echo "PWD != $HOME/bin."
    echo "Please run the setup script from $HOME/bin"
    echo "Exiting..."
    exit
fi

if [ "$(uname)" == "Darwin" ]; then
    echo -n "Run setup on a MacOS machine? (yes/NO): "
elif [ "$(uname)" == "Linux" ]; then
    echo -n "Run setup on a Linux machine? (yes/NO): "
else
    echo "Unknown OS - $(uname). Exiting..."
    exit 1
fi

read input
if [ "${input}" != "yes" ]; then
    echo "Invalid input - '$input'"
    echo "Exiting..."
    exit 2
fi

echo "Starting setup..."
source scripts/functions.sh
if [ "$(uname)" == "Darwin" ]; then
    source scripts/setup.macos.sh
elif [ "$(uname)" == "Linux" ]; then
    source scripts/setup.linux.sh
fi

## Setup symlinks to dotfiles
#### bash config
ln -sf ~/bin/bash/bashrc ~/.bashrc
ln -sf ~/bin/bash/bash_profile ~/.bash_profile

### ssh config
[ -L ~/.ssh/config ] && rm ~/.ssh/config
[ -f ~/.ssh/config ] && \
    echo "~/.ssh/config exists. Delete and re-run setup." && exit
mkdir -p ~/.ssh
ln ~/bin/ssh/config ~/.ssh/config
chmod 700 ~/.ssh
chmod 600 ~/.ssh/config

#### git config
ln -sf ~/bin/git/gitconfig ~/.gitconfig

#### tmux config
[ -L ~/.tmux ] && rm ~/.tmux
[ -d ~/.tmux ] && echo "~/.tmux exists. Delete and re-run setup." && exit
ln -sf ~/bin/tmux ~/.tmux
ln -sf ~/bin/tmux/tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux/plugins
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

#### vim config
[ -L ~/.vim ] && rm ~/.vim
[ -d ~/.vim ] && echo "~/.vim exists. Delete and re-run setup." && exit
ln -sf ~/bin/vim ~/.vim
ln -sf ~/bin/vim/vimrc ~/.vimrc
mkdir -p ~/.vim/autoload
mkdir -p ~/.vim/plugins

#### Install all vim plugins
vim +PlugInstall +PlugClean +qall

echo "dotfiles setup complete..."
