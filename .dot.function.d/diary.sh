#!/usr/bin/env bash

function create_engagement_diary() {
  DIR_SUFFIX="$(date +%Y/%m/%d)";
  echo "Creating engagement diary";
  if [ -n "$1" ]; then
    ENGAGEMENT_NAME="$1";
  elif is_pwd_engagement_dir; then
    echo "Attempting to derive engagement name from present working directory...";
    ENGAGEMENT_NAME="$(pwd | sed -e "s|${ENGAGEMENT_BASE_DIR}/||" | cut -d '/' -f 1)";
    echo "✓";
  else
    echo "Unable to determine engagement name as it was not specified and we're not in $ENGAGEMENT_BASE_DIR"
    false;
    return;
  fi

  printf "Configuring 'ENGAGEMENT_DIARY_DIR'... ";
  ENGAGEMENT_DIARY_DIR="${ENGAGEMENT_BASE_DIR}/${ENGAGEMENT_NAME}/diary/${DIR_SUFFIX}";
  echo "✓";
  printf "'ENGAGEMENT_DIARY_DIR'... ";
  DIARY_FILE="${ENGAGEMENT_DIARY_DIR}/${ENGAGEMENT_NAME}.diary";
  echo "✓";
  create_diary "${DIARY_FILE}";
  return;
}

function create_diary() {
  if [ -n "$1" ]; then
    DIARY_FILE="$1";
  else
    echo "A diary file is required. Usage: create_diary /path/to/diary/file";
    false;
    return;
  fi

  DIARY_DIR="$(dirname $DIARY_FILE)";
  echo $DIARY_DIR;
  DIARY_NAME="$(basename $DIARY_FILE)";

  if [ ! -d "${DIARY_DIR}" ]; then
    echo -n "Creating ${DIARY_DIR} ...";
    mkdir -p "${DIARY_DIR}";
    echo "✓";
  else
    echo "Diary dir: ${DIARY_DIR}, already exists";
  fi

  DEFAULT_DIR_SIFFIX="$(date +%Y/%m/%d)";
  DEFAULT_DIR_SUFFIX_LENGTH="$(echo -n ${DEFAULT_DIR_SIFFIX} | wc -m)";
  DIARY_DIR_LENGTH="$(echo -n "${DIARY_DIR}" | wc -m)";

  # DIR_SUFFIX_POSITON represents where DIARY_BASE_DIR ends and DEFAULT_DIR_SUFFIX_LENGTH begins
  DIR_SUFFIX_POSITON="$(((${DIARY_DIR_LENGTH} - ${DEFAULT_DIR_SUFFIX_LENGTH})))";

  # and we can use that to determine what the current DIR_SUFFIX is
  # ASSUMING it's the same format as the DEFAULT_DIR_SUFFIX_LENGTH
  # There should be some validation of $DIR_SUFFIX's format.
  DIR_SUFFIX="${DIARY_DIR:$DIARY_DIR_SUFFIX_POSITON}";
  update_diary_dir "${DIR_SUFFIX}";

  if [ ! -d "${DIARY_CURRENT_DIR}" ]; then
    echo -n "Creating ${DIARY_CURRENT_DIR} ...";
    mkdir -p "${DIARY_CURRENT_DIR}";
    echo "✓";
  fi

  echo -n "Creating diary ${DIARY_FILE} ...";
  touch "${DIARY_CURRENT_DIR}/${DIARY_NAME}" &&\
   ln -s "${DIARY_CURRENT_DIR}/${DIARY_NAME}" "${DIARY_FILE}" &&\
   diary_entry "created diary: ${DIARY_CURRENT_DIR}/${DIARY_NAME} & linked to ${DIARY_FILE}" &&\
   echo "✓" && return;

  echo "Unable to create ${DIARY_CURRENT_DIR}/${DIARY_NAME} & link it to diary file: ${DIARY_FILE}";
  false;
}

function diary_entry() {
  if [ -z "$1" ]; then
    echo "Diary entry is required. Usage diary_entry: \"Today ruled! (^:\"";
    false;
    return;
  elif [ -f "$1" -a -r "$1" ]; then
    echo "Oooh, cool. You passed a file; adding the contents of '$1' to the diary";
    DIARY_CONTENT="$(cat $1)";
  else
    DIARY_CONTENT=$1;
  fi

  DIR_SUFFIX="$(date +%Y/%m/%d)";
  update_diary_dir "${DIR_SUFFIX}";
  if is_pwd_engagement_dir; then
    ENGAGEMENT_NAME="$(pwd | sed -e "s|$ENGAGEMENT_BASE_DIR/||" | cut -d '/' -f 1)";
    ENGAGEMENT_DIARY_DIR="${ENGAGEMENT_BASE_DIR}/${ENGAGEMENT_NAME}/diary/${DIR_SUFFIX}";
    ENGAGEMENT_DIARY_FILE="${ENGAGEMENT_BASE_DIR}/${ENGAGEMENT_NAME}/diary/${DIR_SUFFIX}/${ENGAGEMENT_NAME}.diary";
  else
    DIARY_FILE="${DIARY_CURRENT_DIR}/general.diary";
  fi
  DIARY_ENTRY="$(date +%T): ${1}";
  echo "${DIARY_ENTRY}" >> "${DIARY_FILE}" && return;
  false
}

function update_diary_dir() {
  if [ -z "${1}" ]; then
    DIR_SUFFIX=$(date +%Y/%m/%d);
  else
    DIR_SUFFIX=${1};
  fi
  echo "Updating DIARY_CURRENT_DIR to ${DIARY_BASE_DIR}/${DIR_SUFFIX}";
  export DIARY_CURRENT_DIR=${DIARY_BASE_DIR}/$DIR_SUFFIX && return;
  false;
}
