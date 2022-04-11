#!/usr/bin/env bash

function get_dir () {
  printf "%s" "$(basename "$(pwd)")";
}

# If file exists as a regular file or directory; and is readable, return true!
function file_exists () {
  [ -d "$1" ] && [ -r "$1" ] && return 0;
  [ -f "$1" ] && [ -r "$1" ] && return 0;
  return 1;
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
    file_exists "$file" || return 1;
  done

  return 0;
}

# Accept a list of strings...
# Returns 0 on the condition that any element in the list is a readable file,
# or directory; however, If this function is passed a directory;
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

  echo "$file_check_result" | grep -q '0' && return 0;

  return 1;
}

# can tell if you're in a "project" directory
function is_pwd_project_dir () {
  if [ -z "$PROJECT_BASE_DIR" ]; then
    echo "Unable to determine if $(pwd) is an project dir as " \
    "PROJECT_BASE_DIR is not set.";
    return 1;
  fi
  pwd | grep -qE "$PROJECT_BASE_DIR/" || return 1;
  return 0;
}

function is_project_dir () {
  if [ -z "$PROJECT_BASE_DIR" ]; then
    echo "PROJECT_BASE_DIR is not set"
    echo "Unable to determine if $1 is an project dir";
    return 1;
  else
    local project_dir=("$1" "$(realpath "$1" 2>/dev/null)");
    for dir in "${project_dir[@]}"; do
      file_exists "$dir" && \
      echo "$1" | grep -qE "$PROJECT_BASE_DIR/" || return 1;
    done
  fi
  return 0;
}

# can tell if you're in a python project's root directory
function is_python_project() {
  local python_project_files='./.python-version'\
  './requirements.txt'\
  './*.pyc'\
  './setup.py';
  any_files_exist "$python_project_files" && return 0;
  return 1;
}

function is_node_project() {
  NODE_PROJECT_FILES="./package.json";
  any_files_exist "$NODE_PROJECT_FILES" && return 0;
  return 1;
}

function is_go_project() {
  return 1;
}
