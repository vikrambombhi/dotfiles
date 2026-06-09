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

# Completion: offer the directory names under ~/dev and ~/Projects
function _dev_dirs() {
    local d
    for d in "$HOME/dev"/*/ "$HOME/Projects"/*/; do
        [ -d "$d" ] && basename "$d"
    done
}

if [ -n "$ZSH_VERSION" ]; then
    function _dev() {
        local -a names
        names=( ${(f)"$(_dev_dirs)"} )
        compadd -a names
    }
    # Ensure the completion system is loaded before registering.
    if ! whence compdef >/dev/null 2>&1; then
        autoload -Uz compinit && compinit -u
    fi
    compdef _dev dev
elif [ -n "$BASH_VERSION" ]; then
    function _dev() {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "$(_dev_dirs)" -- "$cur") )
    }
    complete -F _dev dev
fi
