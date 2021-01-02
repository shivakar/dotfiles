#!/usr/bin/env bash

which brew &> /dev/null
exit_on_error "brew command not found"

echo "Restoring brew bundle"
brew bundle install --file packages/Brewfile
exit_on_error "brew bundle install failed"

echo "Added homebrew bash to /etc/shells..."
grep /usr/local/bin/bash /etc/shells &> /dev/null
if [ "$?" != "0" ]; then
    echo "/usr/local/bin/bash" | sudo tee -a /etc/shells > /dev/null
    exit_on_error "adding homebrew bash to /etc/shells failed"
fi
