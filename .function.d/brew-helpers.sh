#!/usr/bin/env bash

#
# A bunch of helper functions for brew (^:
#

function check_ownership() {

  local check_dir="${1}";

  [ -z "${check_dir}" ] && check_dir="/usr/local/share/man/man8";

  gstat --format "\

  %n is a %F... It was:

    - Created       @ %w;
    - Data Modified @ %y;
    - Last Accessed @ %x;
    - Satus Changed @ %z;
  " "${check_dir}";

  return;
}

# function fix_ownership() {
#   local user;
#   local index;
#   local stat_cmd;
#   local stat_cmd_suffix;
#   local file_to_check="${1}";
#
#   while ! file_exists "$file_to_check"; do
#     [ -z "$file_to_check" ] &&\
#      file_to_check="/usr/local/share/man/man8" &&\
#      continue;
#     return 1;
#   done
#
#   user=( "$( gid --real )" "$( gid )" );
#   stat_cmd="sudo gstat -L --printf '%u|%U' ${file_to_check}";
#   stat_cmd_suffix="cut -d '|' -f ";
#
#   declare -a owner;
#
#   # $(stat_cmd_result) == "${user[$index]}";
#   for index in seq "${user[$#]}"; do
#     owner["${index}"]="$(${stat_cmd}${stat_cmd_suffix}${index})";
#
#     if [ "${user[$index]}" != "${owner[$index]}" ]; then
#       return 1;
#     fi
#   done
#
#   # (brew config | grep $HOMEBREW_PREFIX | cut -d ':' -f 2 | tr -d # ' ')
#
#   # name_match="$([ "$("${stat_command} -f 2")" == # "${user['id']}"])";
#
#   #chmod u+w "/usr/local/share/man/man8" || return;
#   #return 0;
#   return 0;
# }
#
function fix_man8 () {
   sudo chown -R "$(whoami)" "/usr/local/share/man/man8" && \
   chmod u+w "/usr/local/share/man/man8" && \
   return 0;

   return 1;
 }
