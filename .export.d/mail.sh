
#!/usr/bin/env bash

# shellcheck disable=SC2155

export MAIL_STORAGE_LOCAL="${HOME}/mail";
export MAIL_DOMAIN="mail.battiston.biz";
export MAIL_ADDRESS_SUFFIX="@${MAIL_DOMAIN}";

#declare -A MAIL_ACCOUNT_NAME_REMOTE_MAPPING=(\
# [admin]='s3://biz-battiston-mail'\
# [mikey]='s3://biz-battiston-mail-mikey' \
#);
#
#declare -A MAIL_SUPPORTED_ACTIONS=(\
# [ls]='aws s3 sync --quiet'\
# [sync]='aws s3 ls --recursive --human-readable --summarize' \
#);
#
