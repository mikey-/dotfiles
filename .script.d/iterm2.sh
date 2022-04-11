#!/usr/bin/env bash

if [ "${TERM_PROGRAM}" = "iTerm.app" ]; then
  #printf "\033]1337;SetUserVar=%s=%s\007" "python_version" get_python_version;
  #printf "\033]1337;SetUserVar=%s=%s\007" "node_version" get_node_version;
  #printf "\033]1337;SetUserVar=%s=%s\007" "info" user_info;
  function iterm2_print_user_vars() {
    iterm2_set_user_var "python_version" "$(get_python_version)";
    iterm2_set_user_var "node_version" "$(get_node_version)";
    iterm2_set_user_var "ruby_version" "$(get_ruby_version)";
    iterm2_set_user_var "info" "$(user_info)";
    iterm2_set_user_var "aws_env" "$(basename "$AWS_ENV_DIR")";
    iterm2_set_user_var "diary" "$DIARY_CURRENT_DIR";
    iterm2_set_user_var "aws_profile" "$AWS_DEFAULT_PROFILE";
    iterm2_set_user_var "conda_env" "$CONDA_DEFAULT_ENV";
  }

fi

# shellcheck disable=SC1090
test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

