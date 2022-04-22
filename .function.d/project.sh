#!/usr/bin/env bash

# shellcheck disable=SC1091
# shellcheck disable=SC1090

source "${DOTFILE_DIR}/.function.d/file_helpers.sh"

function create_project () {
  if [ -n "${1}" ]; then
    PROJECT_NAME="${1}";
  else
    echo "Project name required. Usage: create_project 'project-name'";
    false;
    return;
  fi

  # setup project directory structure
  PROJECT_DIR="${PROJECT_BASE_DIR}/${PROJECT_NAME}";
  echo "Hi! gonna try to create ${PROJECT_DIR}";

  if [ ! -r "${PROJECT_DIR}" ] && [ ! -d "${PROJECT_DIR}" ]; then
    PROJECT_DIR_LIST="repos diary documents scripts tmp";
    for PD in $PROJECT_DIR_LIST; do
      echo "Creating ${PROJECT_DIR}/${PD}";
      mkdir -p "${PROJECT_DIR}/${PD}";
    done
    unset PD;
    # setup a diary for the project
    create_project_diary "${PROJECT_NAME}";
  else
    echo "Could not create project directory; ${PROJECT_DIR}:";
    [ -d "${PROJECT_DIR}" ] && echo "  - ${PROJECT_DIR} already exists";
    [ -r "${PROJECT_DIR}" ] && echo "  - ${PROJECT_DIR} is readable";
    echo "";
    return 1;
  fi

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

function cdp () {
  if [ -n "$PROJECT_BASE_DIR" ]; then
    local project_dir=("$1" "$PROJECT_BASE_DIR/$1");
    for dir in "${project_dir[@]}"; do
      if is_project_dir "${dir}"  && file_exists "${dir}"; then
        echo "$dir";
        cd "$dir" && return 0;
      fi
    done
  fi
  return 1;
}
