#!/usr/bin/env zsh

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
	echo -n "Installing Rosetta"
	softwareupdate --install-rosetta --agree-to-license

	if [ ! -f /opt/homebrew/bin/brew ]; then
		echo -n "Installing homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi

	if [ ! -f /opt/homebrew/bin/brew ]; then
		echo -n "Homebrew installation was not successful. Exiting..."
		exit 3
	fi


	echo -n "Installing packages from Brewfile."
	/opt/homebrew/bin/brew bundle install --file=Brewfile

	export PATH=/opt/homebrew/bin:$PATH
	sudo ln -sfn /opt/homebrew/bin/pinentry-curses /usr/local/bin
fi

if command -v op &> /dev/null; then
	op signin &> /dev/null
	if [[ "$?" != "0" ]]; then
		echo "Please link 1password CLI and rerun setup.sh"
		exit 4
	fi
else
	echo "Please install 1Password CLI and rerun setup.sh"
	exit 5
fi


## Setup symlinks to dotfiles

### zsh config
echo "Installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
ln -sf ~/bin/zsh/zshrc ~/.zshrc
ln -sf ~/bin/zsh/inputrc ~/.inputrc
touch ~/.localbashrc

op document get p10k.zsh --out-file ~/.p10k.zsh --force

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

### ssh config
ln -sfn ~/bin/ssh/ ~/.ssh
mkdir ~/.ssh/config.d
op document get id_rsa.pub --out-file ~/.ssh/id_rsa.pub --force
op document get id_rsa --out-file ~/.ssh/id_rsa --force
op document get id_ed25519_cardno_22275657.pub --out-file ~/.ssh/id_ed25519_cardno_22275657.pub --force
op document get "ssh/config.d/personal" --out-file ~/.ssh/config.d/personal --force
chmod 700 ~/.ssh
chmod 600 ~/.ssh/authorized_keys
chmod 400 ~/.ssh/*.pub
chmod 400 ~/.ssh/id_rsa


### gnupg config
ln -sfn ~/bin/gnupg ~/.gnupg
chmod 700 ~/.gnupg
op document get master.pub.key --out-file ~/.gnupg/master.pub.key --force
op document get ownertrust.txt --out-file ~/.gnupg/ownertrust.txt --force
gpg --import < ~/.gnupg/master.pub.key
gpg --import-ownertrust < ~/.gnupg/ownertrust.txt

### git config
ln -sf ~/bin/git/gitconfig ~/.gitconfig

### Final instructions
echo ""
echo "dotfiles setup complete..."
echo "Restart the terminal and then do the following:"
echo "  1. Run `p10k configure` to install missing fonts and enable iterm2 integration."

