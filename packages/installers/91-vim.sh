#!/usr/bin/env bash

NAME=vim
VERSION=8.0.0019
NAMEVER=${NAME}-${VERSION}
BASEURL=https://github.com/vim/vim/archive/v${VERSION}.tar.gz

if [ -d /opt/apps/${NAME}/${VERSION} ]; then
    echo "[INFO] ${NAMEVER} already installed. Nothing to do. Exiting."
    exit
fi

mkdir -p ~/Sources
mkdir -p ~/Build

if [ ! -f ~/Sources/${NAMEVER}.tar.gz ]; then
    echo "[INFO] Downloading ${NAMEVER}..."
    wget -qc ${BASEURL} -O ~/Sources/${NAMEVER}.tar.gz
fi

cd ~/Build
rm -rf ${NAMEVER}
tar xvf ~/Sources/${NAMEVER}.tar.gz

echo "[INFO] Installing prerequisite packages..."
sudo yum install -y ruby ruby-devel lua lua-devel luajit \
                    luajit-devel ctags git python python-devel \
                    tcl-devel perl perl-devel perl-ExtUtils-ParseXS \
                    perl-ExtUtils-XSpp perl-ExtUtils-CBuilder \
                    perl-ExtUtils-Embed

echo "[INFO] Building ${NAMEVER}..."
cd ~/Build/${NAMEVER}
./configure --prefix=/opt/apps/${NAME}/${VERSION} \
            --with-features=huge \
            --enable-multibyte \
            --enable-cscope \
            --enable-luainterp \
            --enable-perlinterp \
            --enable-pythoninterp \
            --enable-rubyinterp \
            --enable-tcpinterp
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

setenv("VIMROOT",               installBase)
setenv("VIMHOME",               installBase)
prepend_path("PATH",            pathJoin(installBase, "bin"))

EOT
sudo cp ${VERSION}.lua ${MODULEDIR}/${VERSION}.lua

echo "Done."

