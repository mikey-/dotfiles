#!/usr/bin/env bash

PS1="";

function set_prompt (){
  PS1="$(user_info)";
  export PS1;
}

function clear_prompt () {
  export PS1="";
}

function set_prompt_command () {

  [ -z "$PROMPT_COMMAND" ] && PROMPT_COMMAND="${PROMPT_COMMAND}";
  [ -z "$PS1" ] && clear_prompt;

  #local mikePrompt="load_aws_env;";
  PROMPT_COMMAND="load_aws_env;${PROMPT_COMMAND}";

}

set_prompt_command;
