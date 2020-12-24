#!/bin/bash

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

# inform about local changes, update will not be possible before commit
if ! git diff-index --quiet HEAD --; then
	echo -e "${RED}You have uncommited changes in linuxEnv repo ($(dirname $(pwd)))${NC}"
	echo "Auto update is impossible until you commit or drop following changes:"
	git status -s
	exit 1 	
fi

# update once a day
UPDATED=$(cat updated.date 2>/dev/null)
NOW=$(date +%Y-%m-%d)
if [[ "$UPDATED" == "$NOW" ]]; then
	exit 0	
fi

echo "Updating linuxEnv..."
git pull --rebase | grep -i 'up to date.' &> /dev/null
if [ $? == 0 ]; then
   echo "nothing to update!"
else 
	../install.sh update 
	echo -e "\nUpdate finished!"
fi

echo $NOW > updated.date
