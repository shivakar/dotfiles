#!/usr/bin/env bash

NAME=go
VERSION=1.7.4
NAMEVER=${NAME}-${VERSION}
BASEURL=https://storage.googleapis.com/golang/go${VERSION}.linux-amd64.tar.gz

if [ -f /opt/apps/${NAME}/${VERSION}/bin/${NAME} ]; then
    echo "[INFO] ${NAMEVER} already installed. Nothing to do. Exiting."
    exit
fi

mkdir -p ~/Sources
mkdir -p ~/Build

if [ ! -f ~/Sources/${NAMEVER}.tar.gz ]; then
    echo "[INFO] Downloading ${NAMEVER}..."
    wget -qc ${BASEURL} -O ~/Sources/${NAMEVER}.tar.gz
fi
echo "[INFO] Uncompressing archive..."
cd ~/Build
rm -rf go
tar xvf ~/Sources/${NAMEVER}.tar.gz

echo "[INFO] Installing ${NAMEVER}..."
sudo mkdir -p /opt/apps/${NAME}
sudo cp -rf go /opt/apps/${NAME}/${VERSION}
sudo find /opt/apps/${NAME}/${VERSION} -type d -print0 | xargs -0 sudo chmod 755
sudo chown root:root -Rf /opt/apps/${NAME}/${VERSION}

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

setenv('GOROOT',     installBase)
prepend_path('PATH', pathJoin(installBase, "bin"))
EOT

sudo cp -f ${VERSION}.lua ${MODULEDIR}/${VERSION}.lua
sudo chown root:root ${MODULEDIR}/${VERSION}.lua
echo "Done."

