#!/bin/bash

set -e

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

ZSHRC=~/.zshrc
OHMYZSH_DIR=~/.oh-my-zsh

EXTENSION_MARK=#--INSTALLER_EXTENSION--

function set_zshrc_param {
	REGEXP="^[[:space:]*#?[[:space:]]*$1=.*$"
	MUSTBE=$1=$2
	if grep -qP "$REGEXP" $ZSHRC; then
		sed -i "s|$REGEXP|$1=$2|g" $ZSHRC  
	else
		echo $MUSTBE >> $ZSHRC
	fi
}

function resolve {
	echo $1 | sed "s|\$INSTALL_DIR|$INSTALL_DIR|g"
}

# install ohmyszhs
if [ -e $OHMYZSH_DIR ]; then
	if [[ "$1" != "-f" ]]; then
		echo "you seem to have ohmyzsh already installed"
		read -r -p "Do you want to update config(u) or exit(e)? [u/E] " response
		response=${response,,}    # tolower
		if [[ ! "$response" =~ ^(u)$ ]]; then
			echo "zhs is already installed, update cancelled"
			exit 0
		fi
	fi
	UPDATE_ONLY=true
fi

# install ZSH if not installed
if [[ -v $UPDATE_ONLY ]]; then
	wget -O zsh_install.sh https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh
	chmod +x ./zsh_install.sh
	pwd
	./zsh_install.sh
fi

# customize zsh with our options (overwriting if exists)
while read p; do
	RESOLVED=$(resolve "$p")
	set_zshrc_param $RESOLVED 
done < params.list

# start adding new options to .zshrc: first, remove old stuff

sed "/$EXTENSION_MARK/,\$d" $ZSHRC > zshrc.bak
rm $ZSHRC
mv zshrc.bak $ZSHRC
echo "$EXTENSION_MARK" >> $ZSHRC

# add aliases
chmod +x $INSTALL_DIR/aliases.sh
echo ". $INSTALL_DIR/aliases.sh" >> $ZSHRC

# add dynamic local aliases: all scripts in ~/.oh-my-zsh/aliases.rc will be called
cat <<EOT >> $ZSHRC
if [ -e $OHMYZSH_DIR/aliases.rc ]; then
	for f in $OHMYZSH_DIR/aliases.rc ; do
		bash "$f" -H 
	done
fi
EOT

# add plugins
echo "plugins+=($(cat $INSTALL_DIR/plugins.inc))" >> $ZSHRC

# link themes
for f in themes/*.zsh-theme
do
	ln -sf $(realpath $f) $OHMYZSH_DIR/$f 
done

# add autoupdate (resticted to every N days)
echo "$(realpath $INSTALL_DIR)/autoupdate.sh" >> $ZSHRC

# include user's plain stuff
cat plain.inc >> $ZSHRC
