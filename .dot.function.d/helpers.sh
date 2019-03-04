#!/usr/bin/env bash

# A bunch of helper functions used by soooo many other functions and scripts (^:

# source_dotfiles

function source_dotfiles () {
  local file="";
  shopt -s dotglob
  for file in "$HOME"/.dot.*.d/*; do
  	echo -n "Sourcing '$file'... ";
  	if [ -r "$file" ] && [ -f "$file" ]; then
      # linter: shellcheck can't follow the glob so...
      # shellcheck disable=SC1090
      if source "$file"; then
        echo "✓"
      else
        echo "✗";
  		  echo "Unable to source  ${file}. See reasons below:";
  		  [ ! -f "$file" ] && echo "├─'$file' does not exist or is not a regular file.";
  		  [ ! -r "$file" ] && echo "└─'$file' is not readable";
      fi
    fi
  done;
  shopt -u dotglob;
  clear;
  return;
}


# If file exists as a regular file or directory; and is readable, return true!
function file_exists () {
  [ -f "$1" ] && [ -r "$1" ] && return;
  [ -d "$1" ] && [ -r "$1" ] && return;
  false;
}

# If ALL files in the file list exist as a regular file or directory;
# and they're ALL readable, return true!
# If this function is passed a directory;
# It will attmept to perform it's function on the files inside the directory
function all_files_exist () {
  local file;
  local file_list="";
  if [ -d "$1" ] && [ -r "$1" ]; then
    file_list=$(find "$1" -maxdepth 1 | tail -n+2);
  else
    file_list="$1";
  fi

  for file in $file_list; do
    file_exists "$file" || return;
  done

  return;
}

# If any file in the file list exists as a regular file or directory; and is readable, return true!
# If this function is passed a directory;
# It will attmept to perform it's function on the files inside the directory
function any_files_exist () {
  local file;
  local file_list="";
  local file_check_result="";
  if [ -d "$1" ] && [ -r "$1" ]; then
    file_list=$(find "$1" -maxdepth 1 | tail -n+2);
  else
    file_list="$1";
  fi

  for file in $file_list; do
    file_exists "$file";
    file_check_result="${file_check_result}${?}";
  done

  echo "$file_check_result" | grep -q '0' && return;

  false;
}

###########PWD Helper functions#################

# can tell if you're in a "engagement" directory
function is_pwd_engagement_dir () {
  if [ -z "$ENGAGEMENT_BASE_DIR" ]; then
    echo "Unable to determine if $(pwd) is an engagement dir: ENGAGEMENT_BASE_DIR is not set.";
    pwd | grep -qE "$ENGAGEMENT_BASE_DIR/";
  fi
  return;
}

# can tell if you're in a python project's root directory
function is_python_project() {
  local python_project_files="./.python-version ./requirements.txt ./*.pyc ./setup.py ";
  any_files_exist "$python_project_files" && return;
  false;
}

function is_node_project() {
  local node_project_files="./package.json";
  any_files_exist "$node_project_files" && return;
  false;
}

function is_go_project() {
  false;
}

##################### Random stuff: could possibly be in their own file###################
function last_command () {
  fc -l -1 | cut -d ' ' -f 2-;
}

check_last_command () {
  last_com=$(last_command);
  [ "$last_com" == "$1" ] && return;
  false;
}

#function echo_command () {
#  if $(/usr/bin/command lolcat 2>/dev/null 1>/dev/null); then
#    echo "$1" | lolcat;
#  else
#    echo "$1";
#  fi
#}
