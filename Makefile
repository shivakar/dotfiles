SHELL := $(shell [ -x /bin/zsh ] && echo /bin/zsh || echo /usr/bin/zsh)
export PATH := /opt/homebrew/bin:/usr/bin:/bin:/usr/local/bin:$(PATH)
export OPTOKEN := $(shell PATH=$(PATH) op signin --raw)'
# Define a variable for the op command that checks if OPTOKEN is set; only happens in Linux
OP_CMD := $(shell if [ -z "$$OPTOKEN" ]; then echo "op"; else echo "op --session $$OPTOKEN"; fi)

.PHONY: all check-op setup setup-macos setup-linux zsh tmux ssh gnupg gitconfig nvim done clean

all: setup

setup: setup-macos setup-linux zsh tmux ssh gnupg gitconfig nvim done

check-op:
	@if [ -z "$$OPTOKEN" ]; then \
		echo "Please install 1Password CLI and rerun the setup."; \
		exit 5; \
	fi

setup-macos:
	@if [ "$$(uname)" = "Darwin" ]; then \
		echo "Running macOS setup"; \
		if [ ! -f /opt/homebrew/bin/brew ]; then \
			echo "    Installing Homebrew"; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
		fi; \
		echo "    Installing packages from Brewfile."; \
		/opt/homebrew/bin/brew bundle install --file=Brewfile; \
		if [ ! -f /opt/homebrew/bin/pinentry-curses ]; then ; \
			sudo ln -sfn /opt/homebrew/bin/pinentry-curses /usr/local/bin; \
		fi; \
		echo "    Setting up TouchID for sudo"; \
		if [ ! -f /etc/pam.d/sudo_local ]; then \
                        echo "    /etc/pam.d/sudo_local not found, copying from template"; \
                        sudo cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local; \
                fi; \
		grep -q '^#auth       sufficient     pam_tid.so' /etc/pam.d/sudo_local && sudo sed -i '' '/^#auth       sufficient     pam_tid.so/s/^#//' /etc/pam.d/sudo_local; \
		echo "Done setting up MacOS"; \
	fi

setup-linux:
	@if [ "$$(uname)" = "Linux" ]; then \
		user="$$(whoami)"; \
		echo "Running Linux setup"; \
		echo "Switching $${user}'s default shell to /usr/bin/zsh"; \
		sudo chsh -s /usr/bin/zsh $${user}; \
		echo "Installing packages from dnffile."; \
		tail -n +2 dnffile | xargs sudo dnf install -q -y; \
		echo "Installing additional software."; \
		go install github.com/junegunn/fzf@latest; \
		mkdir "$$HOME/.npm"; \
		npm config set prefix "$$HOME"/.npm; \
		npm install -g vscode-langservers-extracted typescript-language-server typescript; \
	fi

zsh:
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		echo "Installing oh-my-zsh"; \
		sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	fi
	@ln -sf "$$(pwd)/zsh/zshrc" "$$HOME/.zshrc"
	@ln -sf "$$(pwd)/zsh/inputrc" "$$HOME/.inputrc"
	@ln -sf "$$(pwd)/zsh/p10k.zsh" "$$HOME/.p10k.zsh"
	@ln -sf "$$(pwd)/zsh/zprofile" "$$HOME/.zprofile"
	@touch "$$HOME/.localbashrc"

tmux:
	@echo "Setting up tmux configuration"
	@ln -sfn "$$HOME/dotfiles/tmux" "$$HOME/.tmux"
	@ln -sf "$$HOME/dotfiles/tmux/tmux.conf" "$$HOME/.tmux.conf"
	@mkdir -p "$$HOME/.tmux/plugins"
	@if [ ! -d "$$HOME/.tmux/plugins/tpm" ]; then \
		git clone https://github.com/tmux-plugins/tpm "$$HOME/.tmux/plugins/tpm"; \
	fi

ssh:
	@echo "Setting up SSH configuration"; \
	if [ -d "$$HOME/.ssh" ]; then; \
		echo "\033[31m"; \
		echo "$$HOME/.ssh already exists. Please backup, delete and rerun to setup ssh."; \
		echo "Skipping SSH setup\033[0m"; \
	else; \
		ln -sfn "$$HOME/dotfiles/ssh" "$$HOME/.ssh"; \
		mkdir -p "$$HOME/.ssh/config.d"; \
		$(OP_CMD) document get id_rsa.pub --out-file "$$HOME/.ssh/id_rsa.pub" --force; \
		$(OP_CMD) document get id_rsa --out-file "$$HOME/.ssh/id_rsa" --force; \
		$(OP_CMD) document get id_ed25519_cardno_22275657.pub --out-file "$$HOME/.ssh/id_ed25519_cardno_22275657.pub" --force; \
		$(OP_CMD) document get "ssh/config.d/personal" --out-file "$$HOME/.ssh/config.d/personal" --force; \
		chmod 700 "$$HOME/.ssh"; \
		chmod 600 "$$HOME/.ssh/authorized_keys"; \
		chmod 400 "$$HOME/.ssh/"*.pub; \
		chmod 400 "$$HOME/.ssh/id_rsa"; \
	fi

gnupg:
	@echo "Setting up GnuPG configuration"; \
	mkdir -p ~/.gnupg; \
	chmod 700 "$$HOME/.gnupg"; \
	$(OP_CMD) document get C4B3535F1244AE35-pub.asc --out-file "$$HOME/.gnupg/C4B3535F1244AE35-pub.asc" --force; \
	$(OP_CMD) document get C4B3535F1244AE35-sec.asc --out-file "$$HOME/.gnupg/C4B3535F1244AE35-sec.asc" --force; \
	$(OP_CMD) document get master.pub.key --out-file "$$HOME/.gnupg/master.pub.key" --force; \
	$(OP_CMD) document get ownertrust.txt --out-file "$$HOME/.gnupg/ownertrust.txt" --force; \
	gpg --import "$$HOME/.gnupg/master.pub.key"; \
	gpg --import "$$HOME/.gnupg/C4B3535F1244AE35-pub.asc"; \
	gpg --import "$$HOME/.gnupg/C4B3535F1244AE35-sec.asc"; \
	gpg --import-ownertrust "$$HOME/.gnupg/ownertrust.txt"

gitconfig:
	@echo "Setting up Git configuration"; \
	ln -sf "$$HOME/dotfiles/git/gitconfig" "$$HOME/.gitconfig"; \
	$(OP_CMD) document get gitconfig.personal --out-file "$$HOME/dotfiles/git/gitconfig.personal" --force

nvim:
	@echo "Setting up Neovim configuration"; \
	ln -sf "$$(pwd)/nvim" "$$HOME/.config/nvim"; \
	echo "Remember to manually install lua-language-server and superhtml..."

done:
	@echo ""; \
	echo "dotfiles setup complete..."; \
	echo "Restart the terminal and then do the following:"; \
	echo ""

clean:
	rm ~/.gitconfig
	rm ~/.gnupg
	rm ~/.inputrc
	rm ~/.p10k.zsh
	rm ~/.ssh
	rm ~/.tmux
	rm ~/.tmux.conf
	rm ~/.vim
	rm ~/.zshrc
	rm ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim
