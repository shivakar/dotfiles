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
    echo "Not tested yet..."
    exit 100
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

