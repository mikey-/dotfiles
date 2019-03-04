#!/usr/bin/env bash

findinssh () {
  FIS_GREP_OPTIONS=""
  if [ "$1" == "ip" ]; then
    FIS_GREP_OPTIONS="-B 2 -A 5";
  elif [ "$1" == "host" ]; then
    FIS_GREP_OPTIONS="-B 1 -A 6";
  else
    echo "Usage: findinssh [host HOSTNAME | ip IP ADDRESS]";
    return 1;
  fi
  grep $FIS_GREP_OPTIONS ~/.ssh/config -e "$2"
}

