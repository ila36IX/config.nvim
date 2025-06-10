#!/bin/env bash

check_if_fzf_exits()
{
	if ! which fzf; then
		echo "Error: install fzf first" 1>&2
		echo "Link: https://raw.githubusercontent.com/junegunn/fzf/refs/heads/master/install" 1>&2
		exit 1
	fi
}

check_if_fzf_exits

if [[ -z "$1" ]]; then
	LAB_DIR=/mnt/d/filelab/
else
	LAB_DIR=$1
fi

FILE_LAB_DIRS=$(find $LAB_DIR -maxdepth 2 -not \( -path '*/.git*' -prune \) -not \( -path '*/node_modules*' -prune \) -type d -print)
CUSTOM_DIR="
$HOME/.config/nvim
"
SELECTED_DIR=$(echo "$FILE_LAB_DIRS" "$CUSTOM_DIR" | fzf)

# Nothing selected
if [[ -z "$SELECTED_DIR" ]]; then
	exit 0
fi

echo $SELECTED_DIR
TMUX_SESSION_ID=$(basename $SELECTED_DIR)

switch_to_session()
{
	if [[ -z "$TMUX" ]]; then # if user is not already in a tmux session
		tmux attach-session -t $TMUX_SESSION_ID
	else
		tmux switch-client -t $TMUX_SESSION_ID
	fi
}


if tmux has-session -t=$TMUX_SESSION_ID 2>/dev/null; then
	switch_to_session
else
	tmux new-session -ds $TMUX_SESSION_ID -c "$SELECTED_DIR" "nvim ."
	tmux new-window -t "$TMUX_SESSION_ID" -c "$SELECTED_DIR" -n term
	tmux select-window -t "$TMUX_SESSION_ID":1
	switch_to_session
fi
