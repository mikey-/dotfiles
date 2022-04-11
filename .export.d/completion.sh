#!/usr/bin/env bash


# [ -z "$PIP_INSTALL_DIR" ] && PIP_INSTALL_DIR="${HOME}/.local/bin";
#
# AWS_COMPLETION_PATH="${PIP_INSTALL_DIR}/aws_completer";

AWS_COMPLETION_PATH="$(/usr/bin/command -v aws_completer)";
export  AWS_COMPLETION_PATH;
complete -C "${AWS_COMPLETION_PATH}" aws;
