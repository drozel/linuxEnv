#!/bin/bash

MTX=./update.lock

INSTALL_DIR="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $INSTALL_DIR

# inform about local changes, update will not be possible before commit
if ! git diff-index --quiet HEAD --; then
	echo -e "${RED}You have uncommited changes in linuxEnv repo ($(dirname $(pwd)))${NC}"
	echo "Auto update is impossible until you commit or drop following changes:"
	git status -s
	exit 1 	
fi

# if update running, wait
WAIT_SEC=10
SEC_ELAPSED=0
if [ -f $MTX ]; then
	echo "another update process running, waiting for it..."
	while [ -f $MTX ]; do
		sleep 1
		SEC_ELAPSED=$((SEC_ELAPSED+1))

		if [ "$SEC_ELAPSED" -gt "$WAIT_SEC" ]; then
			echo "foreign updating process takes longer than $WAIT_SEC seconds, stop waiting it"
			exit 1
		fi
	done

	echo "foreign update finished, you might need to call '. ~/.zshrc' to use the last environment"
fi

# update once a day
UPDATED=$(cat updated.date 2>/dev/null)
NOW=$(date +%Y-%m-%d)
if [[ "$UPDATED" == "$NOW" ]]; then
	exit 0	
fi

touch $MTX

echo "Updating linuxEnv..."
git pull --rebase | grep -i 'up to date.' &> /dev/null
if [ $? == 0 ]; then
   echo "nothing to update!"
else 
	../install.sh update 
	echo -e "\nUpdate finished!"
fi

echo $NOW > updated.date

rm $MTX
