#!/usr/bin/env bash

function create_engagement () {
  if [ -n "${1}" ]; then
    ENGAGEMENT_NAME="${1}";
  else
    echo "Engagement name required. Usage: create_engagement 'client-name'";
    false;
    return;
  fi

  # setup engagement directory structure
  ENGAGEMENT_DIR="${ENGAGEMENT_BASE_DIR}/${ENGAGEMENT_NAME}";
  echo "Hi! gonna try to create ${ENGAGEMENT_DIR}, based on ${ENGAGEMENT_CONFIG}'s rules";
  #check for engagement config
  if [ ! -r "${ENGAGEMENT_CONFIG}" ]; then
    echo "  - it's not readable!";
    false;
  elif [ ! -r "${ENGAGEMENT_DIR}" ] && [ ! -d "${ENGAGEMENT_DIR}" ]; then
    ENGAGEMENT_DIR_LIST=$(grep 'DIRS:' "$ENGAGEMENT_CONFIG" | cut -d ':' -f 2 );
    ENGAGEMENT_FILE_LIST=$(grep 'FILES:' "$ENGAGEMENT_CONFIG" | cut -d ':' -f 2);
    # as new lines are going to be converted to spaces and
    # will delimit the file content list, convert spaces in file content to:
    EFC_SPACE_CHAR='∞';
    # could be annoying but this means the character: ∞
    # is not considered uncool for file content at this stage
    ENGAGEMENT_FILE_CONTENT_LIST=$(grep 'FILE_CONTENT:' "$ENGAGEMENT_CONFIG" | cut -d ':' -f 2 | tr ' ' "$EFC_SPACE_CHAR");

    for ED in $ENGAGEMENT_DIR_LIST; do
      echo "Creating ${ENGAGEMENT_DIR}/${ED}";
      mkdir -p "${ENGAGEMENT_DIR}/${ED}";
    done
    unset ED;

    for EF in $ENGAGEMENT_FILE_LIST; do
      echo "Creating ${ENGAGEMENT_DIR}/${EF}";
      touch "${ENGAGEMENT_DIR}/${EF}";
    done
    unset EF;

    for EFC in $ENGAGEMENT_FILE_CONTENT_LIST; do
      ECF_FILENAME=$(echo "$EFC" | cut -d '|' -f 1 | tr "$EFC_SPACE_CHAR" ' ');
      ECF_CONTENT=$(echo "$EFC" | cut -d '|' -f 2 | tr "$EFC_SPACE_CHAR" ' ');
      if [ ! -r "${EFC}" ]; then
        echo "${EFC} - it's not readable!";
        false;
        return;
      else
        echo "Adding content to ${ECF_FILENAME}";
        printf "%s" "$ECF_CONTENT" > "$ECF_FILENAME";
      fi
    done
    unset EFC;
    unset ECF_CONTENT;
    unset ECF_FILENAME;
    # setup a diary for the engagement
    create_engagement_diary "${ENGAGEMENT_NAME}" && diary_entry "Created diary for $ENGAGEMENT_NAME";
  else
    echo "Could not create engagement directory; ${ENGAGEMENT_DIR}:";
    [ -d "${ENGAGEMENT_DIR}" ] && echo "  - already exists";
    [ -r "${ENGAGEMENT_DIR}" ] && echo "  - it's readable too";
    echo "";
    false;
  fi

  return;
}

function is_pwd_engagement_dir () {
  pwd | grep -qE "${ENGAGEMENT_BASE_DIR}/";
  return;
}
