#!/usr/bin/env bash

if [ "${PWD}" != "$HOME/bin" ]; then
    echo "PWD != $HOME/bin."
    echo "Please run the setup script from $HOME/bin"
    echo "Exiting..."
    exit
fi

echo -n "This will overwrite dotfiles. Are you sure? ('yes' to continue)? "
read resp
if [ "${resp}" != "yes" ]; then
    echo "Invalid response - '$resp'"
    echo "Exiting..."
    exit 2
fi

echo "Startin setup..."

## Setup symlinks to dotfiles

### zsh config
ln -sf ~/bin/zsh/zshrc ~/.zshrc
ln -sf ~/bin/zsh/inputrc ~/.inputrc
touch ~/.localbashrc

### ssh config
ln -sfn ~/bin/ssh/ ~/.ssh

### gnupg config
ln -sfn ~/bin/gnupg ~/.gnupg

### git config
ln -sf ~/bin/git/gitconfig ~/.gitconfig

#### tmux config
ln -sfn ~/bin/tmux ~/.tmux
ln -sf ~/bin/tmux/tmux.conf ~/.tmux.conf
mkdir -p ~/.tmux/plugins
[ ! -d ~/.tmux/plugins/tpm ] && git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
~/.tmux/plugins/tpm/bin/install_plugins

#### vim config
ln -sfn ~/bin/vim ~/.vim
vim +PlugInstall +PlugClean +qall

### Setup TouchID for sudo
grep "pam_tid.so" /etc/pam.d/sudo &>/dev/null || \
    (echo "Setting up TouchID for sudo" && sudo gsed -i '2 i auth       sufficient     pam_tid.so' /etc/pam.d/sudo)

echo "dotfiles setup complete..."