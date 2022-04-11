#!/usr/bin/env bash

source ${DOTFILE_DIR}/.function.d/file_helpers.sh

declare RUBY_DIR;
declare RUBY_VERSION_FILE;
declare RUBY_VERSION;
declare RUBY_PATH;

# RUBY_DIR="$(dirname "${DOTFILE_DIR}")/ruby";
# echo "$RUBY_DIR";
# echo "$RUBY_VERSION_FILE";
# echo "$RUBY_VERSION";
# echo "$RUBY_PATH";

RUBY_DIR="${DOTFILE_DIR}/dev/tools/ruby";
RUBY_VERSION_FILE="${RUBY_DIR}/.ruby-version";

#file_exists "${RUBY_VERSION_FILE}" || \
#echo "RUBY_VERSION_FILE doesn't exist at ${RUBY_VERSION_FILE}";

file_exists "${RUBY_VERSION_FILE}" || \
RUBY_VERSION_FILE="${DOTFILE_DIR}/.ruby-version";

RUBY_VERSION="$(cat "${RUBY_VERSION_FILE}")";
RUBY_PATH="${RUBY_DIR}/${RUBY_VERSION}";

export RUBY_DIR=$RUBY_DIR
export RUBY_VERSION_FILE=$RUBY_VERSION_FILE
export RUBY_VERSION=$RUBY_VERSION
export RUBY_PATH=$RUBY_PATH
export PATH="${RUBY_PATH}/bin:$PATH"
