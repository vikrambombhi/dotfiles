#!/bin/bash
#
# Simple script that opens any folder in the ~/dev directory in a tmux session
# Usage:
#  dev <dir_name>
#
function dev() {
    DIR_NAME=$1

    DIR_PATH="$HOME/dev/$DIR_NAME"
    WORK_DIR_PATH="$HOME/Projects/$DIR_NAME"

    # if directory exists
    if [ -d $DIR_PATH ]; then
        # -c sets the working directory
        # -A attaches to the session if it already exists
        # -s sets the session name
        tmux new -c $DIR_PATH -A -s $DIR_NAME 
    elif [ -d $WORK_DIR_PATH ]; then
        tmux new -c $WORK_DIR_PATH -A -s $DIR_NAME 
    else
        echo "$DIR_PATH does not exist"
    fi
}
