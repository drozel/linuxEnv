#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR
        
# update once a day
UPDATED=$(cat updated.date 2>/dev/null)
NOW=$(date +%Y-%m-%d)
if [[ "$UPDATED" == "$NOW" ]]; then
	exit 0	
fi

echo "Updating linuxEnv..."
#git pull --rebase
../install.sh -f
echo "Update finished!"

echo $NOW > updated.date

