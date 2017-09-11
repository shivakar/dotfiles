#!/usr/bin/env bash

which yum &> /dev/null
exit_on_error "yum command not found"

echo "Running yum update..."
sudo yum update -y
exit_on_error "yum update failed"

echo "Installing required packages using yum..."
packages=$(cat packages/yum-packages.txt)
sudo yum install -y ${packages}
exit_on_error "yum install failed"
