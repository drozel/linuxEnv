#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

UPDATEBLE=updateble

for d in */ ; do
	echo "Installing $d ..."

	if [ -f "$d/install.sh" ]; then
		echo -e "\t• install script"
		bash $d/install.sh $1
	fi

	if [ -f "$d/symlinks" ]; then
		while read -r t l; do 
			if [ -z $l ] || [ -z $t ]; then 
				echo -e "\t\tsymlinks entry is broken: $t $l"
				exit 1
			fi

			if [ -f $l ]; then 
				cp $l $(dirname $l)/$l.bak
			fi 

			if [ "$(readlink -- "$l")" = $t ]; then
				continue
			fi

			FULLTARGET=$(realpath $d/$t)
			LINK=$(eval echo $l)
			echo -e "\t• creating symlink $LINK to $FULLTARGET"
			ln -sf $FULLTARGET $LINK

		done < $d/symlinks 	
	fi

	echo "done!"
	echo ""
done
