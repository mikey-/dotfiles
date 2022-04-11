#!/usr/bin/env bash

function create_project_diary() {
  DIR_SUFFIX="$(date +%Y/%m/%d)";
  echo "Creating project diary";
  if [ -n "$1" ] || is_project_dir "$1"; then
    PROJECT_NAME="$1";
  elif is_pwd_project_dir; then
    printf "Attempting to derive project name from present working directory... ";
    PROJECT_NAME="$(pwd | sed -e "s|${PROJECT_BASE_DIR}/||" | cut -d '/' -f 1)";
    echo "✓";
  else
    #echo "Unable to determine project name";
    echo "Unable to determine project name for $1.";
    return 1;
  fi

  printf "Configuring 'PROJECT_DIARY_DIR'... ";
  PROJECT_DIARY_DIR="${PROJECT_BASE_DIR}/${PROJECT_NAME}/diary/${DIR_SUFFIX}";
  echo "✓";

  create_diary "${PROJECT_DIARY_DIR}/${PROJECT_NAME}.diary";

  return;
}

function create_diary() {
  if [ -z "$1" ]; then
    echo "A diary file is required. Usage: create_diary /path/to/diary/file";
    return 1;
  else
    DIARY_DIR="$(realpath -Lm "$(dirname "$1")")";
    DIARY_NAME="$(basename "$1")";
    DIARY_FILE="${DIARY_DIR}/${DIARY_NAME}";
  fi

  if [ ! -d "${DIARY_DIR}" ]; then
    echo -n "Creating '${DIARY_DIR}'... " || return;
    mkdir -p "${DIARY_DIR}";
    echo "✓";
  else
    echo "Won't create '${DIARY_DIR}', as it already exists";
  fi

  # If DIARY_DIR = DIARY_BASE_DIR + some suffix: calculate the suffix & include
  # it into the current context for diary operations. Otherwise just use the
  # date :)
  # shellcheck disable=SC2256
  if [[ $DIARY_BASE_DIR =~ $DIARY_DIR ]]; then
    DIR_SUFFIX="$(echo $"DIARY_DIR" | sed -e "s|${DIARY_BASE_DIR}||g")";
  fi

  if [ -z "$DIR_SUFFIX" ]; then
    DIR_SUFFIX="$(date +%Y/%m/%d)";
  fi

  # DIR_SUFFIX_LENGTH="$(echo -n "${DIR_SUFFIX}" | wc -m)";
  # DIARY_DIR_LENGTH="$(echo -n "${DIARY_DIR}" | wc -m)";

  # echo "$(wc -m < <(realpath -Lm "$DIARY_DIR"))"
  # This variable represents the index position DIARY_BASE_DIR meets DEFAULT_DIR_SUFFIX_LENGTH.
  # DIARY_DIR_SUFFIX_POSITION="$(((DIARY_DIR_LENGTH - DIR_SUFFIX_LENGTH)))";

  # and we can use that to determine what the current DIR_SUFFIX is
  # ASSUMING it's the same format as the DEFAULT_DIR_SUFFIX_LENGTH
  # There should be some validation of $DIR_SUFFIX's format.
  # DIR_SUFFIX="${DIARY_DIR:$DIARY_DIR_SUFFIX_POSITION}";

  update_diary_dir "${DIR_SUFFIX}" || return;

  if [ ! -d "${DIARY_CURRENT_DIR}" ]; then
    echo -n "Creating '${DIARY_CURRENT_DIR}'... ";
    mkdir -p "${DIARY_CURRENT_DIR}";
    echo "✓";
  fi

  echo "Creating diary '${DIARY_FILE}'... ";
  touch "${DIARY_CURRENT_DIR}/${DIARY_NAME}" &&\
   ln -s "${DIARY_CURRENT_DIR}/${DIARY_NAME}" "${DIARY_FILE}" &&\
   diary_entry "Created diary '${DIARY_CURRENT_DIR}/${DIARY_NAME}'" &&\
   diary_entry "Linked diary to ${DIARY_FILE}" &&\
   return 0;

  echo "Unable to create '${DIARY_CURRENT_DIR}${DIARY_NAME}' & link it to diary file: ${DIARY_FILE}";
  return 1;
}

function diary_entry() {
  if [ -z "$1" ]; then
    echo "Diary entry is required. Usage diary_entry: \"Today ruled! (^:\"";
    false;
    return;
  elif [ -f "$1" ] && [ -r "$1" ]; then
    echo "Oooh, cool. You passed a file; adding the contents of '$1' to the diary";
    DIARY_CONTENT="$(cat "$1")";
  else
    DIARY_CONTENT="$1";
  fi

  DIR_SUFFIX="$(date +%Y/%m/%d)";
  update_diary_dir "${DIR_SUFFIX}";

  if ! file_exists "$DIARY_CURRENT_DIR"; then
    echo "Creating $DIARY_CURRENT_DIR";
    mkdir -p "$DIARY_CURRENT_DIR";
  fi

  if is_pwd_project_dir; then
    PROJECT_NAME="$(pwd | sed -e "s|${PROJECT_BASE_DIR}/||" | cut -d '/' -f 1)";
    PROJECT_DIARY_DIR="${PROJECT_BASE_DIR}/${PROJECT_NAME}/diary/${DIR_SUFFIX}";
    PROJECT_DIARY_FILE="${PROJECT_BASE_DIR}/${PROJECT_NAME}/diary/${DIR_SUFFIX}/${PROJECT_NAME}.diary";
    DIARY_NAME="${PROJECT_NAME}.diary";

    if ! file_exists "$PROJECT_DIARY_DIR"; then
      echo "Creating $PROJECT_DIARY_DIR";
      mkdir -p "$PROJECT_DIARY_DIR";
    fi

    if ! file_exists "$PROJECT_DIARY_FILE"; then
      echo "Creating symlink to ${DIARY_CURRENT_DIR}/${DIARY_NAME} @ $PROJECT_DIARY_FILE";
      ln -s "${DIARY_CURRENT_DIR}/${DIARY_NAME}" "$PROJECT_DIARY_FILE";
    fi
  fi

  if [ -z "$DIARY_NAME" ]; then
    DIARY_NAME="general.diary";
  fi

  DIARY_FILE="${DIARY_CURRENT_DIR}/${DIARY_NAME}";

  echo "Diary to be updated: $DIARY_FILE";
  echo "$(date +%T): ${DIARY_CONTENT}" >> "$DIARY_FILE" && return;

  false
}

function update_diary_dir() {
  if [ -z "${1}" ]; then
    DIR_SUFFIX=$(date +%Y/%m/%d);
  else
    DIR_SUFFIX="${1}";
  fi
  # echo "Updating DIARY_CURRENT_DIR to ${DIARY_BASE_DIR}/${DIR_SUFFIX}";
  export DIARY_CURRENT_DIR=${DIARY_BASE_DIR}/$DIR_SUFFIX && return;
  false;
}

function list_all_diaries() {
  if [ -n "$1" ]; then
    ls "$1" "${DIARY_BASE_DIR}"/**/**/**/ && return;
  else
    ls "${DIARY_BASE_DIR}"/**/**/**/ && return;
  fi

  false;
}

function show_diary() {
  if [ -n "$1" ]; then
    echo "Showing diary for $1";
    DIARY_NAME="$1";
  elif is_pwd_project_dir; then
     PROJECT_NAME="$(pwd | sed -e "s|${PROJECT_BASE_DIR}/||" | cut -d '/' -f 1)";
     DIARY_NAME="$PROJECT_NAME";
     echo "Showing diary for project: $PROJECT_NAME";
  else
    echo "Showing all diaries";
    DIARY_NAME="*"
  fi

  # cat "${DIARY_BASE_DIR}"/**/**/**/"${DIARY_NAME}".diary && return;
  local DIARY_LIST='';
  local DIARY='';
  local DISPLAY_COMMAND='';

  DIARY_LIST=$(find  "${DIARY_BASE_DIR}" -type f -name "${DIARY_NAME}".diary | sort);

  if command -v pless 2>/dev/null 1>/dev/null; then
    DISPLAY_COMMAND=pless;
  else
    DISPLAY_COMMAND=less;
  fi

  local DISPLAY_CONTENT='';
  for DIARY in ${DIARY_LIST}; do
    local DIARY_SUFFIX='';
    DIARY_SUFFIX=$(dirname "$DIARY" | sed -e "s|${DIARY_BASE_DIR}/||g" | tr '/' '-');
    DISPLAY_CONTENT="${DISPLAY_CONTENT}
${DIARY_NAME}.diary:${DIARY_SUFFIX}
$(cat -ns "$DIARY")";
  done;

  #$DISPLAY_COMMAND "$DISPLAY_CONTENT";
  printf "[0;00m%s[0;00m" "${DISPLAY_CONTENT}" | $DISPLAY_COMMAND && return;
  #echo -e "${DISPLAY_CONTENT}" | $DISPLAY_COMMAND && return;

  false;
}
