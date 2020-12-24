#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

UPDATEBLE=updateble

for d in */ ; do
	if [ ! -f "$d/install.sh" ]; then
		continue
	fi

	echo -n "Installing $d ... "
	if [[ "$1" = "update" ]] &&  [ ! -f "$d/$UPDATEBLE" ]; then
		echo "skipped due to noupdate"
		continue
	fi

	bash ./$d/install.sh $1

	echo "done!"
done
