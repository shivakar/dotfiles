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

echo "Starting setup..."

### Package Setup
if [[ "$(uname)" == "Linux" ]];
then
	user=$(whoami)
	echo "Switching ${user}'s default shell to /usr/bin/zsh"
	sudo chsh -s /usr/bin/zsh $user

	echo -n "Installing packages from dnffile."
	tail -n +2 dnffile  | xargs sudo dnf install

	echo -n "Installing additional software."
	go install github.com/junegunn/fzf@latest
elif [[ "$(uname)" == "Darwin" ]];
then
	echo -n "Installing package from Brewfile."
	brew bundle install --file=Brewfile
fi

## Setup symlinks to dotfiles

### zsh config
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
type vim &>/dev/null && vim +PlugInstall +PlugClean +qall

### Setup TouchID for sudo
if  [[ "$(uname)" == "Darwin" ]];
then
	grep "pam_tid.so" /etc/pam.d/sudo &>/dev/null || \
	    (echo "Setting up TouchID for sudo" && sudo gsed -i '2 i auth       sufficient     pam_tid.so' /etc/pam.d/sudo)
fi


echo "dotfiles setup complete..."
