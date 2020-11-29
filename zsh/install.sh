#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

ZSHRC=~/.zshrc
OHMYZSH_DIR=~/.oh-my-zsh

function set_zshrc_param {
	REGEXP="^[[:space:]*#?[[:space:]]*$1=.*$"
	MUSTBE=$1=$2
	if grep -qP "$REGEXP" $ZSHRC; then
		sed "s|$REGEXP|$1=$2|g" $ZSHRC  
	else
		echo $MUSTBE >> $ZSHRC
	fi
}

# install ohmyszhs
if [ -e $OHMYZSH_DIR ]; then
	echo "you seem to have ohmyzsh already installed"
	read -r -p "Do you want to update config(u) or exit(e)? [u/E] " response
	response=${response,,}    # tolower
	if [[ ! "$response" =~ ^(u)$ ]]; then
		echo "zhs is already installed, update cancelled"
		exit 0
	fi
	UPDATE_ONLY=true
fi

# install ZSH if not installed
if [[ -v a ]]; then
	wget -O zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	sh zsh_install.sh
fi

# customize zsh with our options (overwriting if exists)
while read p; do
	set_zshrc_param $p
done < params.list

# add aliases
chmod +x $INSTALL_DIR/aliases.sh
echo ". $INSTALL_DIR/aliases.sh" >> $ZSHRC

# add dynamic local aliases: all scripts in ~/.oh-my-zsh/aliases.rc will be called
cat <<EOT >> $ZSHRC
if [ -e $OHMYZSH_DIR/aliases.rc ]; then
	for f in $OHMYZSH_DIR/aliases.rc ; do
		bash "$f" -H 
	done
EOT

# add plugins
echo "plugins+=($(cat $INSTALL_DIR/plugins.inc))"
