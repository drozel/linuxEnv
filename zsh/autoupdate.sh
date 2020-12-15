#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR
        
# update once a day
UPDATED=$(cat updated.date 2>/dev/null)
NOW=$(date +%Y-%m-%d)
if [[ "$UPDATED" == "$NOW" ]]; then
	exit 0	
fi

echo -n "Updating linuxEnv..."
git pull --rebase | grep 'is up to date.' &> /dev/null
if [ $? == 0 ]; then
   echo "nothing to update!"
else 
	../install.sh -f
	echo -e "\nUpdate finished!"
fi

echo $NOW > updated.date

