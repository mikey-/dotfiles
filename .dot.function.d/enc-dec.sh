#!/usr/bin/env bash

# Functions to encrypt and decrypt files using:
# - AES-256
# - no salt

function encrypt_or_decrypt () {
  local \
  EOD \
  OPTIND \
  INFILE \
  OUTFILE \
  EOD_CHAIN \
  EOD_OPTION \
  EOD_ERRLOG \
  EOD_COMMAND \
  INFILE_REALPATH \
  TEMP_EOD_ERRLOG \
  OUTFILE_REALPATH \
  LOCAL_ERRLOG_DIR;

  while getopts ":edi:lo:" EOD_OPTION; do
    case "$EOD_OPTION" in
      e)
        EOD_COMMAND="/usr/local/opt/openssl/bin/openssl enc -aes-256-cbc -a";
        EOD="encrypt";
        EOD_CHAIN="${EOD_CHAIN}:$EOD";
      ;;
      d)
        EOD_COMMAND="/usr/local/opt/openssl/bin/openssl enc -aes-256-cbc -a -d";
        EOD="decrypt";
        EOD_CHAIN="${EOD_CHAIN}:$EOD";
      ;;
      i) INFILE="$OPTARG" ;;
      o) OUTFILE="$OPTARG" ;;
      l) LOCAL_ERRLOG_DIR="$(pwd)" ;;
      :)
        echo "No argument specified for option -$OPTARG...";
        false;
        return;
      ;;
      \?)
        echo "Invalid option: $OPTARG" >&2;
        echo "Usage: encrypt_or_decrypt -e -d -i unencrypted-file -o encrypted-file [-l]";
        false;
        return;
      ;;
    esac
  done

  if [ -n "$LOCAL_ERRLOG_DIR" ]; then
    EOD_ERRLOG="$LOCAL_ERRLOG_DIR"/"$EOD"-errors.log;
  else
    EOD_ERRLOG=${HOME}/"$EOD"-errors.log;
  fi

  TEMP_EOD_ERRLOG="$EOD_ERRLOG-tmp-$(date +"%Y%m%d%H%M%S")-$(uuidgen | cut -c-6)";

  if [ -f "$INFILE" ] && [ -r "$INFILE" ]; then
    INFILE_REALPATH=$(realpath "$INFILE");
    OUTFILE_REALPATH=$(realpath "$OUTFILE");

    echo "${EOD}ing $INFILE to $OUTFILE...";
    if $EOD_COMMAND -in "$INFILE_REALPATH" -out "$OUTFILE_REALPATH" 2>"$TEMP_EOD_ERRLOG" 1>/dev/null; then
      echo "✓" && rm "$TEMP_EOD_ERRLOG" && return;
    else
      echo "✗";
      {
        echo "--------ERROR ${EOD}ing--------" ;
        cat "$TEMP_EOD_ERRLOG";
        echo "EOD: $EOD";
        echo "OPTIND: $OPTIND";
        echo "INFILE: $INFILE";
        echo "OUTFILE: $OUTFILE";
        echo "EOD_CHAIN: $EOD_CHAIN";
        echo "EOD_OPTION: $EOD_OPTION";
        echo "EOD_ERRLOG: $EOD_ERRLOG";
        echo "EOD_COMMAND: $EOD_COMMAND";
        echo "INFILE_REALPATH: $INFILE_REALPATH";
        echo "TEMP_EOD_ERRLOG: $TEMP_EOD_ERRLOG";
        echo "OUTFILE_REALPATH: $OUTFILE_REALPATH";
        echo "LOCAL_ERRLOG_DIR: $LOCAL_ERRLOG_DIR";
      } >> "$EOD_ERRLOG";
      rm "$TEMP_EOD_ERRLOG";
      echo "An error occured, see $EOD_ERRLOG for more details";
    fi
  fi

  false;
}

function encrypt () {
  local PARAMS=(  "$@" );
  PARAMS+=(  "-e" );
  encrypt_or_decrypt "${PARAMS[@]}";
}

function decrypt () {
  local PARAMS=(  "$@" );
  PARAMS+=(  "-d" );
  encrypt_or_decrypt "${PARAMS[@]}";
}
