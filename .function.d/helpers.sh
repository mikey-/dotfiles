#!/usr/bin/env bash

function get_python_version () {
  # is_python_project && \
  printf " %s " "$($(/usr/bin/command -v python) --version 2>&1 | cut -d ' ' -f 2)";
  return 0;
}

function get_ruby_version () {
  # is_ruby_project && \ <- this function doesn't actually exist
  printf " %s " "$($(/usr/bin/command -v ruby) --version 2>&1 | cut -d ' ' -f 2)";
  return 0;
}

function get_go_version () {
  # is_go_project && \
  printf " %s " "$(/usr/bin/command -v go) --version)";
  return 0;
}

function get_node_version() {
  #is_node_project && \
  printf " %s " "$($(/usr/bin/command -v node) -v 2>&1)";
  return 0;
}


function user_info () {
  printf "👨🏽‍💻 ";
  return 0;
}

function load_aws_env () {
  if is_pwd_project_dir; then
    PROJECT_NAME="$(pwd | sed -e "s|${PROJECT_BASE_DIR}/||" | cut -d '/' -f 1)";
    PROJECT_DIR="${PROJECT_BASE_DIR}/${PROJECT_NAME}";
    AWS_ENV_DIR="$PROJECT_DIR";
  elif [ "$(pwd)" == "$HOME" ]; then
    AWS_ENV_DIR="$HOME";
  else
    return 1;
  fi

  local aws_config;
  local aws_credentials;
  aws_config="${AWS_ENV_DIR}/.aws/config";
  aws_credentials="${AWS_ENV_DIR}/.aws/credentials";

  if all_files_exist "${aws_config} ${aws_credentials}"; then
    export AWS_CONFIG_FILE="$aws_config"
    export AWS_SHARED_CREDENTIALS_FILE="$aws_credentials"
    AWS_DEFAULT_PROFILE="$(aws-profiles \
    | grep default \
    | cut -d ' ' -f 2 \
    | head -1)";
    export AWS_DEFAULT_PROFILE;
    return 0;
  fi
  return 1;
}

function get_battery_status () {
  local battery_status;
  battery_status=$(pmset -g batt | tail -1 | tr -d '\t' | sed -Ee 's/.*-InternalBattery-0 \(id=[0-9]+\)([0-9]+%);.*/\1/g' -e 's/%/%/g')
  printf "🔋 %s " "$battery_status";
  return 0;
}

function clock () {
  local clock_format;
  clock_format="%Y-%m-%d %H:%M:%S";
  printf "⌚️ %s | " "$(date +"${clock_format}")";
  return 0;
}
