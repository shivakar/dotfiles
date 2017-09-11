#!/usr/bin/env bash

NAME=node
VERSION=6.11.2
if [ ! -z "${1}" ]; then
    VERSION="${1}"
fi
NAMEVER=${NAME}-${VERSION}
BASEURL=https://nodejs.org/dist/v${VERSION}/node-v${VERSION}.tar.gz

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
rm -rf ${NAMEVER}
tar xf ~/Sources/${NAMEVER}.tar.gz
mv ${NAME}-v${VERSION} ${NAMEVER}


echo "[INFO] Building ${NAMEVER}..."
cd ~/Build/${NAMEVER}
./configure --prefix=/opt/apps/${NAME}/${VERSION}
make -j 4

echo "[INFO] Installing ${NAMEVER}..."
sudo make install

echo "[INFO] Installing Lmod module file for ${NAMEVER}..."
MODULEDIR=/opt/apps/modulefiles/Core/${NAME}
sudo mkdir -p ${MODULEDIR}
sudo cat > ${VERSION}.lua << EOT
-- -*- lua -*-

help([[
    Module for ${NAME} version ${VERSION}
]])

local base        = "/opt/apps"
local pkgName     = "${NAME}"
local version     = "${VERSION}"
local installBase = pathJoin(base, pkgName, version)

setenv("NODEROOT",              installBase)
prepend_path("PATH",            pathJoin(installBase, "bin"))
prepend_path("INCLUDE",            pathJoin(installBase, "include"))
prepend_path("CPATH",            pathJoin(installBase, "include"))
prepend_path("NODE_PATH",       pathJoin(installBase, "lib", "node_modules"))
prepend_path("NODE_PATH",       "./node_modules")
prepend_path("MANPATH",         pathJoin(installBase, "share/man"))

EOT
sudo cp ${VERSION}.lua ${MODULEDIR}/${VERSION}.lua
echo "Done."

