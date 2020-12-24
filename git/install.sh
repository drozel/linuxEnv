#!/bin/bash

GITCONFIG=~/.gitconfig

function bk {
	if test -f "$1"; then
		BAK=$1.bak
		echo "$1 exists, backing it up as $BAK"
		mv $1 $BAK
	fi
}

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

# check already installed (changes are automatically taken from repo due to symlink)
if [ "$(readlink -- "$GITCONFIG")" = $INSTALL_DIR/.gitconfig ]; then
	echo "$GITCONFIG is already symlink to linuxEnv repo, nothing to install"
	exit 0
fi

# process .gitconfig
bk $GITCONFIG
ln -s $INSTALL_DIR/.gitconfig $GITCONFIG
ln -s $INSTALL_DIR/.gitconfig_knx.inc ~/.gitconfig_knx.inc
