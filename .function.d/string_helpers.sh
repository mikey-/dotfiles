#!/usr/bin/env bash

function test_var_value () {
  local return_value=0;
  {
    if [ $# -lt 1 ] || [ -z "$1" ]; then
      echo "Unset or empty var_name";
      echo "";
      echo "Usage: test_var_value var_name";
      return_value=1;
    else
      local variable_name=$1;
      echo "checking if '${variable_name}' string is unset or empty...";
      echo "using -n";
      if [ -n "${!variable_name}" ]; then
        echo "variable '${variable_name}' is set, and not to an empty string!";
        echo "see for yourself: ${variable_name}='${!variable_name}'";
      else
        echo "variable '${variable_name}' is unset, or set to an empty string!";
        echo "see for yourself: '${variable_name}'='${!variable_name}'";
        return_value=1;
      fi

      echo "checking if string is empty or unset...";
      echo "using -z";
      if [ -z "${!variable_name}" ]; then
        echo "variable '${variable_name}' is unset, or set to an empty string!";
        echo "see for yourself: '${variable_name}'='${!variable_name}'";
        return_value=1;
      else
        echo "variable '${variable_name}' is set, and not to an empty string!";
        echo "see for yourself: '${variable_name}'='${!variable_name}'";
      fi
    fi

  } || return_value=2;

  return ${return_value};
}
