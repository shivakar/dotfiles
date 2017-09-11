#!/usr/bin/env bash

NAME=Lmod
VERSION=7.6.5
if [ ! -z "${1}1" ]; then
    VERSION="${1}"
fi
NAMEVER=${NAME}-${VERSION}
BASEURL=https://github.com/TACC/Lmod/archive/${VERSION}.tar.gz

if [ -d /opt/apps/lmod/${VERSION} ]; then
    echo "[INFO] ${NAMEVER} is already installed. Nothing to do. Exiting."
    exit
fi

mkdir -p ~/Sources
mkdir -p ~/Build

if [ ! -f ~/Sources/${NAMEVER}.tar.gz ]; then
    echo "[INFO] Downloading ${NAMEVER}..."
    wget -c ${BASEURL} -O ~/Sources/${NAMEVER}.tar.gz
fi
cd ~/Build
rm -rf ${NAMEVER}
tar xf ~/Sources/${NAMEVER}.tar.gz
cd $NAMEVER

echo "[INFO] Installing prerequisites..."
sudo yum install -y tcl lua lua-filesystem lua-devel lua-posix lua-term

echo "[INFO] Building ${NAMEVER}..."
./configure --prefix=/opt/apps
make -j 6

echo "[INFO] Installing ${NAMEVER}..."
sudo make install

echo "[INFO] Configuring ${NAMEVER}..."
sudo mkdir -p /opt/apps/modulefiles/{Core,Compiler}
sudo ln -sf /opt/apps/lmod/${VERSION} /opt/apps/lmod/lmod
sudo cp -f /opt/apps/lmod/lmod/init/profile /etc/profile.d/lmod.sh

echo "Done."
