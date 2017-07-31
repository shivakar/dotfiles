#!/usr/bin/env bash

export PATH=/opt/local/bin:$PATH

which port &> /dev/null
exit_on_error "port command not found"

echo "Running port selfupdate..."
sudo port -q selfupdate
exit_on_error "port selfupdate failed"

echo "Upgrading outdated packages..."
output=$(sudo /opt/local/bin/port -q upgrade outdated)
retval=$?
if [[ "${output}" != "Nothing to upgrade." ]] && \
	[[ "${retval}" != "0" ]]; then
    echo "ERROR: port upgrade failed"
    exit 10
fi

echo "Installing required packages using port..."
packages=$(cat packages/port-packages.txt)
sudo port -q install ${packages}
exit_on_error "port install failed"

echo "Added macports bash to /etc/shells..."
grep /opt/local/bin/bash /etc/shells
if [ "$?" != "0" ]; then
    echo "/opt/local/bin/bash" | sudo tee -a /etc/shells > /dev/null
    exit_on_error "could not add macports bash to /etc/shells"
fi
