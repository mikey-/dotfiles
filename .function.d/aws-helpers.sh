#!/usr/bin/env bash

# A bunch of helper functions for the AWS CLI (^:

function get-windows-ami {
  local cli_opt_query;
  local cli_opt_output;
  local ssm_ami_command;
  local ssm_param_root="/aws/service/ami-windows-latest/";
  local ssm_param_alias="Windows_Server-2016-English-Full-Base";
  local windows_ami_parameter="${ssm_param_root}${ssm_param_alias}";

  [ -z "${AWS_ENV_DIR}" ] || load_aws_env || return 1;
  [ -z "${AWS_DEFAULT_PROFILE}" ] || load_aws_env || return 1;

  if [ -n "${1}" ] && [[ ! "json|table|text" =~ $1  ]]; then
    cli_opt_query="--query ${1}";
  elif [ -n "${1}" ] && [[ "json|table|text" =~ $1 ]]; then
    cli_opt_output="--output ${1}";
  elif [ -n "${1}" ] && [ -n "${2}" ]; then
    cli_opt_query="--query ${1}";
    cli_opt_output="--output ${2}";
  fi


  ssm_ami_command="aws ssm get-parameters \
  --names $windows_ami_parameter \
  ${cli_opt_query} \
  ${cli_opt_output}";

  $ssm_ami_command;

  return;

}

function aws-profiles {

  local aws_file_list;

  #shellcheck disable=SC2086
  aws_file_list="$(find \
  -L ${AWS_ENV_DIR}/.aws/* \
  -type f \
  -name config \
  -or \
  -name credentials)"

  #shellcheck disable=SC2086
  #shellcheck disable=SC2002
  cat $aws_file_list |\
  grep '\[' | tr -d '[]' |\
  sed -E 's/(default )?(profile )?//g' || return 1;

  return 0;

}

function describe-instances {

  #shellcheck disable=SC2210
  local _awsh_di_profile="$1";
  local _awsh_di_region="$2";
  local _awsh_di_output="$3";
  local _awsh_di_query="$4";
  declare -a _awsh_di_cmd;

  if [ -z "$1" ] || [ "$1" == "default" ] ; then
    _awsh_di_profile="$AWS_DEFAULT_PROFILE";
  else
    _awsh_di_profile="$1";
  fi

  if [ -z "$2" ] || [ "$2" == "default" ]; then
    _awsh_di_region="";
  else
    _awsh_di_region="--region ${2}";
  fi

  if [ -z "$3" ] || [ "$3" == "default" ]; then
    _awsh_di_output="--output table";
  else
    _awsh_di_output="--output ${3}";
  fi

  if [ -z "$4" ]; then
    _awsh_di_query+='Reservations[].Instances[].{';
    _awsh_di_query+=' "Id": InstanceId,';
    _awsh_di_query+=' "Name": Tags[0].Value,';
    _awsh_di_query+=' "PrivateIp": PrivateIpAddress,';
    _awsh_di_query+=' "PublicIp": PublicIpAddress';
    _awsh_di_query+=' }';
    _awsh_di_query="--query '${_awsh_di_query}'";
  else
    _awsh_di_output="--query '${4}'";
  fi

  _awsh_di_cmd=("aws");
  _awsh_di_cmd+=("--profile ${_awsh_di_profile}");
  _awsh_di_cmd+=("${_awsh_di_region}");
  _awsh_di_cmd+=("${_awsh_di_output}");
  _awsh_di_cmd+=("ec2 describe-instances");
  _awsh_di_cmd+=("${_awsh_di_query}");

  echo "${_awsh_di_cmd[*]}";
  /usr/bin/env bash -c "${_awsh_di_cmd[*]}";

}

# aws --profile swanqa --region ap-southeast-2 cloudformation list-stacks --query  --output table
# list-stacks swanqa ap-southeast-2
function list-stacks {

  #shellcheck disable=SC2210
  local _awsh_ls_profile="$1";
  local _awsh_ls_region="$2";
  local _awsh_ls_stack_name="$3";
  local _awsh_ls_output="$4";
  local _awsh_ls_query="$5";
  declare -a _awsh_ls_cmd;

  if [ -z "$1" ] || [ "$1" == "default" ] ; then
    _awsh_ls_profile="$AWS_DEFAULT_PROFILE";
  else
    _awsh_ls_profile="$1";
  fi

  if [ -z "$2" ] || [ "$2" == "default" ]; then
    _awsh_ls_region="";
  else
    _awsh_ls_region="--region ${2}";
  fi

  if [ -z "$3" ] || [ "$3" == "default" ]; then
    _awsh_ls_stack_name="one-cloud";
  else
    _awsh_ls_stack_name="$3";
  fi

  if [ -z "$4" ] || [ "$4" == "default" ]; then
    _awsh_ls_output="--output table";
  else
    _awsh_ls_output="--output ${4}";
  fi

  if [ -z "$5" ]; then
    _awsh_ls_query+='sort_by(StackSummaries[?';
    _awsh_ls_query+=" contains(StackName,'${_awsh_ls_stack_name}') ";
    _awsh_ls_query+='], &CreationTime)[].{';
    _awsh_ls_query+=' "StackName": StackName,';
    _awsh_ls_query+=' "Status": StackStatus,';
    _awsh_ls_query+=' "CreationTime": CreationTime ';
    _awsh_ls_query+='}';
    _awsh_ls_query="--query \"${_awsh_ls_query}\"";
  else
    _awsh_ls_output="--query \"${5}\"";
  fi

  _awsh_ls_cmd=("aws");
  _awsh_ls_cmd+=("--profile ${_awsh_ls_profile}");
  _awsh_ls_cmd+=("${_awsh_ls_region}");
  _awsh_ls_cmd+=("${_awsh_ls_output}");
  _awsh_ls_cmd+=("cloudformation list-stacks");
  _awsh_ls_cmd+=("${_awsh_ls_query}");

  echo "${_awsh_ls_cmd[*]}";
  /usr/bin/env bash -c "${_awsh_ls_cmd[*]}";

}
