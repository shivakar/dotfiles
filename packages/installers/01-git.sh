#!/usr/bin/env bash

NAME=git
VERSION=2.14.1
NAMEVER=${NAME}-${VERSION}
BASEURL=https://github.com/git/git/archive/v${VERSION}.tar.gz

if [ -f /opt/apps/${NAME}/${VERSION}/bin/${NAME} ]; then
    echo "[INFO] ${NAMEVER} already installed. Nothing to do. Exiting."
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
sudo yum install -y autoconf perl-ExtUtils-MakeMaker curl-devel

echo "[INFO] Building ${NAMEVER}..."
make configure
./configure --prefix=/opt/apps/${NAME}/${VERSION}
make -j 4

echo "[INFO] Installing ${NAMEVER}..."
sudo make install

echo "[INFO] Installing Lmod module file for ${NAMEVER}..."
MODULEDIR=/opt/apps/modulefiles/Core/${NAME}
sudo mkdir -p ${MODULEDIR}
cat > ${VERSION}.lua << EOT
-- -*- lua -*-

help([[
    Module for ${NAME} version ${VERSION}
]])

local base        = "/opt/apps"
local pkgName     = "${NAME}"
local version     = "${VERSION}"
local installBase = pathJoin(base, pkgName, version)

prepend_path("PATH", pathJoin(installBase, "bin"))
EOT

sudo cp ${VERSION}.lua ${MODULEDIR}/${VERSION}.lua

echo "Done."

