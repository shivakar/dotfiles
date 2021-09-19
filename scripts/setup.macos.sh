#!/usr/bin/env bash

which brew &> /dev/null
exit_on_error "brew command not found"

echo "Restoring brew bundle"
brew bundle install --file packages/Brewfile
exit_on_error "brew bundle install failed"
