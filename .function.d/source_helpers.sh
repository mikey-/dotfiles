#!/usr/bin/env bash

function source_dotfiles () {

  local file;
  local dotfile;
  local file_list;
  local dotignore;
  local dotfile_dir;
  local required_dotfiles;

  dotfile="$DOTFILE";
  dotignore="$DOTIGNORE";
  dotfile_dir="$DOTFILE_DIR";

  local dotfile_path="${dotfile_dir}/${dotfile}";
  local dotignore_path="${dotfile_dir}/${dotignore}";

  required_dotfiles="$(grep '\..*\.d' < "${dotfile_path}" | grep -v "$(cat "${dotignore_path}")")";

  shopt -s dotglob;
  for file_list in $required_dotfiles; do
    for file in "${dotfile_dir}/${file_list}"/*; do
      if [ -r "$file" ] && [ -f "$file" ]; then
        # linter: shellcheck can't follow the glob so...
        # shellcheck disable=SC1090
        echo "$file";
        if source "$file"; then
          continue; # ✓
        else
          false; # ✗
        fi
      else
        echo "Unable to source  ${file}. See reasons below:";
        [ ! -f "$file" ] && echo "├─'$file' not found or isn't a regular file";
        [ ! -r "$file" ] && echo "└─'$file' is not readable";
      fi
    done
  done
  shopt -u dotglob;
  return 0;
}
