SHELL := /usr/bin/env zsh

.PHONY: all setup zsh

all: setup

setup: zsh
	@if [ ! -d "$$HOME/.oh-my-zsh" ]; then \
		echo "Installing oh-my-zsh"; \
		sh -c "$$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended; \
	fi
	@ln -sf "$$(pwd)/zsh/zshrc" "$$HOME/.zshrc"
	@ln -sf "$$(pwd)/zsh/inputrc" "$$HOME/.inputrc"
	@ln -sf "$$(pwd)/zsh/p10k.zsh" "$$HOME/.p10k.zsh"
	@touch "$$HOME/.localbashrc"

