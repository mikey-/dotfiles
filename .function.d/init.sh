#!/usr/bin/env bash

export DEFAULT_DOTFILE_DIR="${HOME}/dev/tools/dotfiles";
export DEFAULT_DOTFILE=".dotfile";
export DEFAULT_DOTIGNORE=".dotignore";

# You may overwrite defaults with the following vars
export DOTFILE_DIR="$HOME";
# export DOTFILE=".dotfile";
# export DOTIGNORE=".dotignore"

if [ -z "$DOTFILE_DIR" ]; then
  DOTFILE_DIR="$DEFAULT_DOTFILE_DIR";
fi

if [ -z "$DOTFILE" ]; then
  DOTFILE="$DEFAULT_DOTFILE";
fi

if [ -z "$DOTIGNORE" ]; then
  DOTIGNORE="$DEFAULT_DOTIGNORE";
fi

export DOTFILE_DIR="$DOTFILE_DIR";
export DOTFILE="$DOTFILE";
export DOTIGNORE="$DOTIGNORE";

# shellcheck disable=SC1090
source "${DOTFILE_DIR}/.function.d/source_helpers.sh";
