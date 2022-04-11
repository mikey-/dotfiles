#!/usr/bin/env bash

# email related functions

function mail {

  [ -z "${AWS_ENV_DIR}" ] || load_aws_env || return 1;
  [ -z "${AWS_DEFAULT_PROFILE}" ] || load_aws_env || return 1;

  declare -A ACCOUNT_REMOTE_MAPPING=(\
   [admin]='s3://biz-battiston-mail'\
   [mikey]='s3://biz-battiston-mail-mikey' \
  );

  declare -A MAIL_ACTIONS=(\
   [ls]="aws s3 ls --profile default-personal-admin --recursive --human-readable --summarize ${ACCOUNT_REMOTE_MAPPING[$2]}/${2}"\
   [sync]="aws s3 sync --profile default-personal-admin --quiet ${ACCOUNT_REMOTE_MAPPING[$2]} ${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}" \
  );

  [[ ! -d "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}" ]] || mkdir -p "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}"

  ${MAIL_ACTIONS[${1}]};

  /usr/local/bin/tree -axCFNQ --noreport --sort=mtime "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}";
}
