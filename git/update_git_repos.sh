#!/bin/bash

# This script updates all git repositories in given directory

# colors
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[33m'
BOLD='\033[1m'
NC='\033[0m'

WORKSPACE_DIR=${1:-~/workspace}

GIT_REPOS=$(find $WORKSPACE_DIR -type d \( -exec /usr/bin/test -d "{}/.git" -a "{}" != "." \; -print -prune -o -name .git -prune \))

for REPO in $GIT_REPOS
do
	echo -e "Pulling changes for ${CYAN}${BOLD}$(basename ${REPO})${NC}"
	cd $REPO
	changes=$(git status -s)
	if [[ ! -z $changes ]]; then
		echo -e "${YELLOW}Changes detected! Stashing${NC}"
		git add .
		git stash
		git pull
		echo -e "${YELLOW}Applying stashed changes${NC}"
		git stash apply
	else
		echo -e "${GREEN}No changes to stash, pulling${NC}"
		git pull
	fi
done
