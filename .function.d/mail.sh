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
   [ls]="aws s3 ls --profile ${AWS_DEFAULT_PROFILE} --recursive --human-readable --summarize ${ACCOUNT_REMOTE_MAPPING[$2]}/${2}"\
   [sync]="aws s3 sync --profile ${AWS_DEFAULT_PROFILE} --quiet ${ACCOUNT_REMOTE_MAPPING[$2]} ${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}" \
  );

  [[ ! -d "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}" ]] || mkdir -p "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}"

  ${MAIL_ACTIONS[${1}]};

  tree --sort=mtime "${MAIL_STORAGE_LOCAL}/${2}@${MAIL_DOMAIN}";
}
