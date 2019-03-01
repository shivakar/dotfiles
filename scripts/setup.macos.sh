#!/usr/bin/env bash
return

which brew &> /dev/null
exit_on_error "brew command not found"

echo "Installing taps"
for i in $(cat packages/brew-taps.txt); do
    brew tap $i
    exit_on_error "error installing tap $i"
done

echo "Updating brew and formulae"
brew update
exit_on_error "brew update failed"

echo "Upgrading outdated packages..."
brew upgrade
exit_on_error "brew upgrade failed"

echo "Installing required packages using brew..."
packages=$(cat packages/brew-packages.txt)
brew install ${packages}
exit_on_error "brew install failed"

echo "Added homebrew bash to /etc/shells..."
grep /usr/local/bin/bash /etc/shells &> /dev/null
if [ "$?" != "0" ]; then
    echo "/usr/local/bin/bash" | sudo tee -a /etc/shells > /dev/null
    exit_on_error "adding homebrew bash to /etc/shells failed"
fi

echo "Installing required GUI packages using brew cask..."
packages=$(cat packages/brew-cask-packages.txt)
brew cask install ${packages}
exit_on_error "brew cask install failed"
