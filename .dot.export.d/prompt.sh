#!/usr/bin/env bash

PS1="";

# Unused colours and scm theme stuff.
# mostly from bash.it
#reset="\e[0m";
#bold="\e[1m";
#blink="\e[5m";
#
#blue="\e[0;34m";
#yellow="\e[1;33";
#underline="\e[4m";
#light_gray="\e[37m"
#light_red="\e[1;31m";
#light_cyan="\e[1;36m"
#light_green="\e[1;32m";
#light_magenta="\e[1;35";
#
#scm_theme_prompt_dirty=" ${red}✗"
#scm_theme_prompt_clean=" ${light_green}✓"
#scm_theme_prompt_prefix=" ${light_green}|"
#scm_theme_prompt_suffix="${light_green}|"
#
#git_theme_prompt_dirty=" ${reg}✗"
#git_theme_prompt_clean=" ${light_green}✓"
#git_theme_prompt_prefix=" ${light_green}|"
#git_theme_prompt_suffix="${light_green}|"
#
#rvm_theme_prompt_prefix="|"
#rvm_theme_prompt_suffix="|"

# Prompt Functions

function get_battery_status() {
  battery_status=$(pmset -g batt | tail -1 | tr -d '\t' | sed -Ee 's/.*-InternalBattery-0 \(id=[0-9]+\)([0-9]+%);.*/\1/g' -e 's/%/%/g')
  printf " 🔋 %s " "$battery_status";
}

function get_bt_device_battery_status() {
  bt_batt_stat=$(ioreg -c AppleDeviceManagementHIDEventService -r -k "BatteryPercent")
}

function get_mtp_battey_status() {
  battery_status=$(pmset -g batt | tail -1 | tr -d '\t' | sed -Ee 's/.*-InternalBattery-0 \(id=[0-9]+\)([0-9]+%);.*/\1/g' -e 's/%/%/g')
  printf " 🔋 %s " "$battery_status";
}

function get_btkb_battery_status() {
  battery_status=$(pmset -g batt | tail -1 | tr -d '\t' | sed -Ee 's/.*-InternalBattery-0 \(id=[0-9]+\)([0-9]+%);.*/\1/g' -e 's/%/%/g')
  printf " 🔋 %s " "$battery_status";
}

function clock() {
  clock_format="%Y-%m-%d %H:%M:%S";
  printf "⌚️ %s | " "$(date +"${clock_format}")";
}

function get_python_version() {
  is_python_project && printf "🐍 %s | " "$($(/usr/bin/command -v python) --version 2>&1)";
}

function get_go_version() {
  is_go_project && printf "Go %s | " "$(/usr/bin/command -v go) --version)";
}

function get_node_version() {
  is_node_project && printf "Node.js %s | " "($($(/usr/bin/command -v node) -v))";
}

function user_info () {
  printf "👨🏽‍💻 \u@\h ";
  #if /usr/bin/command -v lolcat; then
  #  printf "👨🏽‍💻 ";
  #  printf "\u" | lolcat;
  #  printf "@\h ";
  #else
  #
  #fi
}

function set_prompt() {
  PS1="\n$(get_battery_status)$(clock)$(get_python_version)$(get_node_version)$(get_go_version)$(user_info)in \w |\n➫ ";
}

function set_prompt_command() {
  if [ -z "$PROMPT_COMMAND" ]; then
    export PROMPT_COMMAND="set_prompt";
  else
    export PROMPT_COMMAND="set_prompt;$PROMPT_COMMAND";
  fi
}

#PS1="\n$(get_battery_status)$(clock)$(get_python_version)$(get_node_version)$(get_go_version)$(user_info)in \w |\n➫ ";
PS1="\n$(get_battery_status)$(user_info)in \w\n➫ ";
#PS1="\nLIAM LIAM LIAM LIAM LIAM LIAM in \w\n➫ ";
#PS1="\nmikey mikey mikey kmikey in \w\n➫ ";
#
#function set_prompt_command() {
#  if [ -z "$PROMPT_COMMAND" ]; then
#    PROMPT_COMMAND="$PS1";
#  else
#    PROMPT_COMMAND="set_prompt;$PROMPT_COMMAND";
#  fi
#}
#
#
set_prompt_command

#if check_last_command "clear"; then
#  PS1="\n$PS1";
#fi
#update_prompt "\n";

#update_prompt "$(get_battery_status)";
#update_prompt "$(clock)";
#is_python_project && update_prompt "$(get_python_version)";
#is_node_project && update_prompt "$(get_node_version)";
#is_go_project && update_prompt "$(get_go_version)";
#update_prompt "$(user_info)"
#update_prompt "in \w |\n➫ ";
#export PS1
