#!/usr/bin/env bash

# Helper Functions

# lets configure the truth
function set_true () {
  true;
  echo $?;
}

function set_false () {
  false;
  echo $?;
}

# say byebye to the dotvars
function unset_dotvar () {
  if [ -z "$1" ]; then
    echo "Invalid DOTVAR: $1";
  else
    unset -v "$1" && return ;
  fi
  false;
}

function echo_command () {
  if /usr/bin/command -v lolcat 2>/dev/null 1>/dev/null; then
    echo "$1" | lolcat;
  else
    echo "$1";
  fi
}

# Would love to add this in but it makes the bootstrap script considerably slower
#function lolcat_check () {
#  if $(/usr/bin/which lolcat 2>/dev/null 1>/dev/null); then
#    lolcat;
#  fi
#}
#
#function unset_everything () {
#  for DOTVAR in $DOTVAR_OPTION_LIST; do
#    printf "unsetting" | lolcat_check;
#    printf " '$DOTVAR'...";
#    unset_dotvar "$DOTVAR";
#    echo "✓" | lolcat_check;
#  done
#
#  for DEFAULT_DOTVAR in $DOTVAR_DEFAULT_OPTION_LIST; do
#    printf "unsetting" | lolcat_check;
#    printf " '$DEFAULT_DOTVAR'...";
#    unset_dotvar "$DEFAULT_DOTVAR";
#    echo "✓" | lolcat_check;
#  done

function unset_everything () {
  for DOTVAR in $DOTVAR_OPTION_LIST; do
    printf "unsetting '$DOTVAR'...";
    unset_dotvar "$DOTVAR";
    echo "✓";
  done

  for DEFAULT_DOTVAR in $DOTVAR_DEFAULT_OPTION_LIST; do
    printf "unsetting '$DEFAULT_DOTVAR'...";
    unset_dotvar "$DEFAULT_DOTVAR";
    echo "✓";
  done

  unset_dotvar "DOTVAR";
  unset_dotvar "DEFAULT_DOTVAR";
  unset_dotvar "DOTVAR_OPTION_LIST";
  unset_dotvar "DOTVAR_DEFAULT_OPTION_LIST";
}

function print_dotvars () {
  for DOTVAR in $DOTVAR_OPTION_LIST; do
    echo "$DOTVAR=${!DOTVAR}";
  done

  unset_dotvar "DOTVAR";
}

# set globals
DOTVAR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )";
#shellcheck disable=SC2034
DEFAULT_DOTVAR_UPDATE_BASH="$(set_false)";
DEFAULT_DOTVAR_RESTORE_BACKUP="$(set_false)";
# shellcheck disable=SC2034
DEFAULT_DOTVAR_RUN_MACOS_SCRIPT="$(set_false)";
DEFAULT_DOTVAR_BACKUP_HOME_FILES="$(set_false)";
DEFAULT_DOTVAR_BACKUP_TO_RESTORE="latest";
DEFAULT_DOTVAR_DOTFILE_LIST="${DOTVAR_DIR}/Dotfile";
DEFAULT_DOTVAR_HOME_FILE_LIST="${DOTVAR_DIR}/Homefile";
DEFAULT_DOTVAR_BACKUP_BASE_DIR="/tmp/dotfile-backups";
DEFAULT_DOTVAR_JUST_COPY="$(set_false)";
DEFAULT_DOTVAR_JUST_COPY_DOTFILE="$(set_false)";
DEFAULT_DOTVAR_DOTFILE="${DOTVAR_DIR}/.bash_profile";
DOTVAR_OPTION_LIST="\
DOTVAR_DOTFILE \
DOTVAR_JUST_COPY \
DOTVAR_UPDATE_BASH \
DOTVAR_DOTFILE_LIST \
DOTVAR_HOME_FILE_LIST \
DOTVAR_RESTORE_BACKUP \
DOTVAR_BACKUP_BASE_DIR \
DOTVAR_RUN_MACOS_SCRIPT \
DOTVAR_BACKUP_HOME_FILES \
DOTVAR_BACKUP_TO_RESTORE \
DOTVAR_JUST_COPY_DOTFILE";
DOTVAR_DEFAULT_OPTION_LIST="\
DEFAULT_DOTVAR_DOTFILE \
DEFAULT_DOTVAR_JUST_COPY \
DEFAULT_DOTVAR_UPDATE_BASH \
DEFAULT_DOTVAR_DOTFILE_LIST \
DEFAULT_DOTVAR_HOME_FILE_LIST \
DEFAULT_DOTVAR_RESTORE_BACKUP \
DEFAULT_DOTVAR_BACKUP_BASE_DIR \
DEFAULT_DOTVAR_RUN_MACOS_SCRIPT \
DEFAULT_DOTVAR_BACKUP_HOME_FILES \
DEFAULT_DOTVAR_BACKUP_TO_RESTORE \
DEFAULT_DOTVAR_JUST_COPY_DOTFILE";

function file_exists () {
  [ -f "${1}" -a -r "${1}" ] && return;
  [ -d "${1}" -a -r "${1}" ] && return;
  false;
}

function install_macos_prefs () {
  if [ "$DOTVAR_RUN_MACOS_SCRIPT" -eq "0" ]; then
    source "${DOTVAR_DIR}/.macos" && return;
  fi
  false;
}

function create_backup () {
  mkdir -p "$DOTVAR_BACKUP_DIR";
  DOTVAR_DOTFILES="$(cat $DOTVAR_DOTFILE_LIST)";
  echo "Backing up dotfiles";
  for DOTVAR_DOTFILE in $DOTVAR_DOTFILES; do
    printf "Backing up '$DOTVAR_DIR/$DOTVAR_DOTFILE' to '$DOTVAR_BACKUP_DIR/' ... ";
    cp -Rp "$HOME/$DOTVAR_DOTFILE" "$DOTVAR_BACKUP_DIR/";
    if [ "$?" -eq "0" ]; then
      echo "✓";
    else
      echo "\nUnable to copy '$HOME/$DOTVAR_DOTFILE' to $DOTVAR_BACKUP_DIR";
    fi
  done
  unset_dotvar "DOTVAR_DOTFILE"
  return;
}

function copy_dotfile () {
  echo "Copying dotfile";
  printf "Copying '$DOTVAR_DIR/$DOTFILE' to '$HOME/'... ";
  cp -Rp $DOTVAR_DIR/$DOTFILE "$HOME/";
  if [ "$?" -eq "0" ]; then
    echo "✓";
  else
    echo "\nUnable to copy ${DOTVAR_DIR}/${DOTFILE} to $HOME";
  fi
  return;
  #cp -Rp ${DOTVAR_DIR}/ ${HOME}/ && rm ${HOME}/bootstrap.sh;
}

function copy_dotfiles() {
  DOTVAR_DOTFILES="$(cat $DOTVAR_DOTFILE_LIST)";
  echo "Copying dotfiles";
  for DOTVAR_DOTFILE in $DOTVAR_DOTFILES; do
    printf "Copying '$DOTVAR_DIR/$DOTVAR_DOTFILE' to '$HOME/' ... ";
    cp -Rp "$DOTVAR_DIR/$DOTVAR_DOTFILE" "$HOME/";
    if [ "$?" -eq "0" ]; then
      echo "✓";
    else
      echo "\nUnable to copy '${DOTVAR_DIR}/${DOTFILE}' to '${HOME}'";
    fi
  done
  return;
  #cp -Rp ${DOTVAR_DIR}/ ${HOME}/ && rm ${HOME}/bootstrap.sh;
}

function install_xcode_clt() {
  xcode-select -p || xcode-select --install;
}

function install_brew() {
  if ! $(which brew 2>/dev/null 1>/dev/null); then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
  fi
}

function install_brew_packages () {
  DOTVAR_BREW_APPS_DIR="${HOME}/Applications";
  file_exists $BREW_APPS_DIR || mkdir $DOTVAR_BREW_APPS_DIR;
  brew bundle;
}

# This will install ggrep for the purpose of installing python during this script
# It will also add ggrep to your Brewfile, if one exists and is readable
function get_ggrep() {
  echo "Installing ggrep from brew";
  brew update && brew install ggrep &&\
   export DOTVAR_GREP_COMMAND="$(/usr/bin/which ggrep)" &&\
   [ $(file_exists "$HOME/Brewfile") ] &&\
   echo "ggrep" >> $HOME/Brewfile && return;
  false;
}

function find_and_install_ggrep () {
  if $(/usr/bin/which ggrep 2>/dev/null 1>/dev/null); then
    export DOTVAR_GREP_COMMAND="$(/usr/bin/which ggrep)";
  elif $(echo "$(man ggrep)" | $(/usr/bin/which grep) "\-P" 2>/dev/null 1>/dev/null); then
    export DOTVAR_GREP_COMMAND="$(/usr/bin/which grep)";
  else
    echo "lmao smdh, I gotta do everything for you, huh?!";
    get_ggrep;
  fi
}

function install_ruby() {
  if ! $(which rvm 2>/dev/null 1>/dev/null); then
    \curl -sSL https://get.rvm.io | bash -s -- --ignore-dotfiles;
    source "$HOME/.rvm/scripts/rvm";
    rvm get stable;
    rvm use --default stable;
  fi
}

function install_node() {
  if ! $(which nvm 2>/dev/null 1>/dev/null); then
    # ensures nvm is installed and that it doesn't touch my dang dotfiles
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | sed -e 's@NVM_PROFILE="$(nvm_detect_profile)"@NVM_PROFILE=""@' | bash;
    source "$HOME/.nvm/nvm.sh";
  fi

  find_and_install_ggrep;

  if $(nvm list | $DOTVAR_GREP_COMMAND -E "default.*lts\/\*.*$(node --version)"); then
    echo "NVM and LTS Node installed"
  else
    nvm install --lts;
    nvm alias default lts/*;
  fi
}

function install_go() {
  if ! $(which gvm 2>/dev/null 1>/dev/null); then
    brew update;
    export GVM_NO_UPDATE_PROFILE=TRUE;
    curl -o- https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash;
    unset -v GVM_NO_UPDATE_PROFILE;
    source "$HOME/.gvm/scripts/gvm";
  fi
  #gvm install go1.11.2;
  #gvm use go1.11.2 [--default];
}

# This will install pyenv for the purpose of installing python during this script
# It would be good if it could setup pyenv too but that's a little out of scope
# That said, it WILL add pyenv to your Brewfile, if one exists and is readable
function get_pyenv () {
  echo "Installing ggrep from brew";
  brew update && brew install pyenv &&\
   file_exists "$HOME"/Brewfile &&\
   echo "pyenv" >> "$HOME"/Brewfile && return;
  false;
}

function python_auto_install() {
  if [ -n "${1}" ]; then
    DOTVAR_INSTALL_PYTHON_VERSION=$1;
  else
    DOTVAR_INSTALL_PYTHON_VERSION=$(pyenv install --list | tr -d ' ' | tail -n+2 | $DOTVOR_GREP_COMMAND -P '^\d+\.\d+\.+\d' | tail -n1);
  fi
  env PYTHON_CONFIGURE_OPTS="--enable-framework" pyenv install "$DOTVAR_INSTALL_PYTHON_VERSION" &&\
   python local $DOTVAR_INSTALL_PYTHON_VERSION && return;
  false;
}

function install_python() {
  DOTVAR_INSTALL_PYTHON_VERSION="";
  DOTVAR_PYENV_VERSION_FILE="$HOME/.python-version";
  if ! $(which pyenv 2>/dev/null 1>/dev/null); then
    echo "omg just gotta go get pyenv real quick...";
    get_pyenv
  fi

  if file_exists "$DOTVAR_PYENV_FILE"; then
    DOTVAR_INSTALL_PYTHON_VERSION="$(cat $DOTVAR_PYENV_FILE)";
  else
    echo "$DOTVAR_PYENV_VERSION_FILE does not exists or is not readible";
    echo "Attempting to install find and latest stable verion of Python";
    find_and_install_ggrep;
  fi
  python_auto_install "$DOTVAR_INSTALL_PYTHON_VERSION" && echo "Python installed :^)" && return;
  unset_dotvar "DOTVAR_INSTALL_PYTHON_VERSION";
  unset_dotvar "GREP_COMMAND";

  #install pip
  if ! $(which pip 2>/dev/null 1>/dev/null); then
    curl -O https://bootstrap.pypa.io/get-pip.py;
    get-pip.py --user;
    rm get-pip.py;
  fi
}

function source_file () {
  if [ -n "$1" ]; then
    source $1;
  else
    echo "Invalid file: unable to source empty file. Usage: source_file \"some-file\"";
  fi
}

function setup_aws_cli() {
  if ! $(command -v aws 2>/dev/null 1>/dev/null); then
    pip3 install awscli --upgrade --user;
  fi
}

create_home_dirs() {
  #HOME_DIR_LIST="dev/engagements dev/scipts dev/tests tmp diary.d";
  echo "Creating directories specified in $DOTVAR_HOME_FILE_LIST";
  DOTVAR_DIR_LIST="$(cat $DOTVAR_HOME_FILE_LIST)";
  for DOTVAR_HOME_DIR in $DOTVAR_DIR_LIST; do
    printf "Checking if $DOTVAR_HOME_DIR already exists... ";
    if [ ! -d "$DOTVAR_HOME_DIR" ]; then
      echo "✓";
      printf "Directory: $DOTVAR_HOME_DIR doesn't exist, creating it...";
      mkdir -p "$DOTVAR_HOME_DIR";
      if [ "$?" -eq "0" ]; then
        echo "✓";
      else
        echo "✗";
        echo "Couldn't not create $DOTVAR_HOME_DIR. R.I.P.";
      fi
    else
      echo "✗";
      echo "Skipping $DOTVAR_HOME_DIR as it already exists!";
    fi
    echo "";
  done;
  unset_dotvar -v "DOTVAR_HOME_DIR";
  unset_dotvar -v "DOTVAR_DIR_LIST";
}

function update_bash() {
  if [ "$UPDATE_BASH" -eq "0" ]; then
    brew install bash;
    # Add the new shell to the list of allowed shells
    sudo bash -c 'echo /usr/local/bin/bash >> /etc/shells';
    # Change to the new shell
    chsh -s /usr/local/bin/bash;
  fi
}

function set_dotvar() {
  if [ -n "$1" ]; then
    DOTVAR_NAME="$1";
  else
    echo "Invalid name for DOTVAR: '$1'";
    return 1;
  fi

  DOTVAR_VALUE=$2;

  if [ -n "$3" ]; then
    DOTVAR_REPRESENTS_FILE=$3;
  else
    DOTVAR_REPRESENTS_FILE="1";
  fi

  if [ -n "$4" ]; then
    DOTVAR_EXIT_ON_FILE_NOT_EXISTANT=$4;
  else
    DOTVAR_EXIT_ON_FILE_NOT_EXISTANT="1";
  fi

  #echo "Trying to set '$DOTVAR_NAME' to '$DOTVAR_VALUE'";
  if [ -n "$DOTVAR_VALUE" ]; then
    export $DOTVAR_NAME=$DOTVAR_VALUE;
  else
    DEFAULT_DOTVAR_NAME="DEFAULT_${DOTVAR_VAR}";
    export $DOTVAR_NAME=${!DEFAULT_DOTVAR_NAME};
  fi

  if [ "$DOTVAR_REPRESENTS_FILE" -eq "0" ]; then
    if ! file_exists "$DOTVAR_VALUE"; then
       echo "Invalid value for '$DOTFILE_NAME: '$DOTVAR_VALUE' is either not a file or it's unreadable";
       unset $DOTVAR_NAME;
       if [ "$DOTVAR_EXIT_ON_FILE_NOT_EXISTANT" -eq "0" ]; then
         echo "Without $DOTVAR_NAME set, this script can't continue";
         exit 1;
       else
         false;
       fi
    fi
  fi
  return;
}

# Go through options list and set default values for any option not set by cli options
# Equivalent of running:
#   set_dotvar DOTVAR_UPDATE_BASH $DOTVAR_DEFAULT_UPDATE_BASH;
#   set_dotvar DOTVAR_RESTORE_BACKUP $DOTVAR_DEFAULT_RESTORE_BACKUP;
#   set_dotvar DOTVAR_BACKUP_BASE_DIR $DOTVAR_DEFAULT_BACKUP_BASE_DIR;
#   set_dotvar DOTVAR_RUN_MACOS_SCRIPT $DOTVAR_DEFAULT_RUN_MACOS_SCRIPT;
#   set_dotvar DOTVAR_BACKUP_HOME_FILES $DOTVAR_DEFAULT_BACKUP_HOME_FILES;
#   set_dotvar DOTVAR_BACKUP_TO_RESTORE $DOTVAR_DEFAULT_BACKUP_TO_RESTORE;
#   set_dotvar DOTVAR_DOTFILE_LIST $DOTVAR_DEFAULT_DOTFILE_LIST;
#   set_dotvar DOTVAR_HOME_FILE_LIST $DOTVAR_DEFAULT_HOME_FILE_LIST;
# Unfortunately we can't tell if $OPTION is meant to be a file so we
# can't really tell set_option to validate it's existance
function set_default_dotvars () {
  for DOTVAR_OPTION in ${DOTVAR_OPTION_LIST}; do
    if [ -z "${!DOTVAR_OPTION}" ]; then
      DOTVAR_DEFAULT_OPTION="DEFAULT_${DOTVAR_OPTION}";
      DOTVAR_DEFAULT_OPTION_VALUE="${!DOTVAR_DEFAULT_OPTION}";
      printf "Setting $DOTVAR_DEFAULT_OPTION to default value: '$DOTVAR_DEFAULT_OPTION_VALUE'... ";
      set_dotvar "$DOTVAR_OPTION" "$DOTVAR_DEFAULT_OPTION_VALUE";
      echo "✓";
      echo "";
    else
      echo "Skipping ${DOTVAR_OPTION} because it already has the value: '${!DOTVAR_OPTION}'";
      echo "";
    fi
  done
  unset_dotvar "DOTVAR_OPTION";
  unset_dotvar "DOTVAR_DEFAULT_OPTION";
  unset_dotvar "DOTVAR_DEFAULT_OPTION_VALUE";

  echo "##############ENV##################";
  print_dotvars;
  echo "##############ENV##################";
}

function run_function () {
  if [ -n "$1" ]; then
    echo_command "⟥+=-=-=-=-=-=*⤻ $1 ⤺*=-=-=-=-=-=+⟤";
    echo "";
    $1;
    if [ "$?" -eq "0" ]; then
      echo_command "✓ ✓ ✓ ✓ ✓ ✓ ✓ ⤻ $1 ⤺ ✓ ✓ ✓ ✓ ✓ ✓ ✓";
      echo "";
      return;
    else
      echo_command "✗ ✗ ✗ ✗ ✗ ✗ ✗ ⤻ $1 ⤺ ✗ ✗ ✗ ✗ ✗ ✗ ✗";
      echo "";
      false;
      return;
    fi
  else
    echo "Invalid function name. Usage: run_function \"do_something\"";
  fi
  false;
}

function main() {
  run_function "copy_dotfiles";
  run_function "install_macos_prefs";
  run_function "install_xcode_clt";
  run_function "install_brew && install_brew_packages";
  run_function "install_ruby";
  run_function "install_node";
  run_function "install_go";
  run_function "install_python";
  run_function "source_file $HOME/.bash_profile";
  run_function "setup_aws_cli";
  run_function "create_home_dirs";
  run_function "unset_everything";
  exit 0
}

function just_copy_stuff () {
  run_function "copy_dotfiles";
  run_function "create_home_dirs";
  run_function "source_file $HOME/.bash_profile";
  run_function "unset_everything";
  exit 0;
}

function just_copy_dotfile () {
  run_function "copy_dotfile";
  run_function "source_file $DOTVAR_DOTFILE";
  run_function "unset_everything";
  exit 0;
}

while getopts ":b:cd:h:mr:uD:" OPTION; do
  case $OPTION in
  b) set_dotvar DOTVAR_BACKUP_BASE_DIR ${OPTARG} "$(set_true)" "$(set_true)"; ;;
  c) set_dotvar DOTVAR_JUST_COPY "$(set_true)" "$(set_false)"; ;;
  d) set_dotvar DOTVAR_DOTFILE_LIST ${OPTARG} "$(set_true)" "$(set_true)"; ;;
  h) set_dotvar DOTVAR_HOME_FILE_LIST ${OPTARG} "$(set_true)" "$(set_true)"; ;;
  m) set_dotvar DOTVAR_RUN_MACOS_SCRIPT "$(set_true)" "$(set_false)"; ;;
  r)
     set_dotvar DOTVAR_RESTORE_BACKUP "$(set_true)" "$(set_false)";
     set_dotvar DOTVAR_BACKUP_TO_RESTORE ${OPTARG} "$(set_true)" "$(set_true)";
     set_dotvar DOTVAR_BACKUP_HOME_FILES "$(set_false)";
     ;;
  u) set_dotvar DOTVAR_UPDATE_BASH "$(set_true)" "$(set_false)"; ;;
  D) set_dotvar DOTVAR_JUST_COPY_DOTFILE "$(set_true)" "$(set_false)";
     set_dotvar DOTVAR_DOTFILE ${OPTARG} "$(set_true)" "$(set_true)";
     ;;
  :)
    echo "No argument specified for option -$OPTARG...";
    DOTVAR_FALLBACK_OPTION="$OPTARG";
    case "$DOTVAR_FALLBACK_OPTION" in
    b) set_dotvar DOTVAR_BACKUP_BASE_DIR ;;
    d) set_dotvar DOTVAR_DOTFILE_LIST ;;
    h) set_dotvar DOTVAR_HOME_FILE_LIST ;;
    r)
      set_dotvar DOTVAR_RESTORE_BACKUP "$(set_true)" "$(set_false)";
      set_dotvar DOTVAR_BACKUP_HOME_FILES "$(set_false)";
      set_dotvar DOTVAR_BACKUP_TO_RESTORE $DEFAULT_DOTVAR_BACKUP_TO_RESTORE "$(set_false)";
    ;;
    D)
      set_dotvar DOTVAR_JUST_COPY_DOTFILE "$(set_true)" "$(set_false)";
      set_dotvar DOTVAR_DOTFILE $DEFAULT_DOTVAR_DOTFILE "$(set_true)" "$(set_false)";
    ;;
    esac
    ;;
  \?)
    echo "Invalid option: $OPTARG" >&2;
    exit 1;
    ;;
  esac
done

#set_option RESTORE_BACKUP $DEFAULT_RESTORE_BACKUP "$(set_false)";
#set_option BACKUP_BASE_DIR $DEFAULT_BACKUP_BASE_DIR "$(set_true)" "$(set_false)";
#set_option RUN_MACOS_SCRIPT $DEFAULT_RUN_MACOS_SCRIPT "$(set_false)";
#set_option BACKUP_HOME_FILES $DEFAULT_BACKUP_HOME_FILES "$(set_false)";
#set_option BACKUP_TO_RESTORE $DEFAULT_BACKUP_TO_RESTORE "$(set_true)" "$(set_false)";
#set_option DOTFILE_LIST $DEFAULT_DOTFILE_LIST "$(set_true)" "$(set_true)";
#set_option HOME_FILE_LIST $DEFAULT_HOME_FILE_LIST "$(set_true)" ""$(set_true)"";

run_function "set_default_dotvars"

echo
if [ "$DOTVAR_JUST_COPY_DOTFILE" -eq "0" ]; then
  echo "Just copying a single dotfile: ${DOTVAR_DOTFILE}, that's all (^:";
  echo "";
  just_copy_dotfile;
elif [ "$DOTVAR_JUST_COPY" -eq "0" ]; then
  echo "Just copying files, that's all (^:";
  echo ""
  just_copy_stuff;
else
  echo "INSTALLING EVERYTHING (^:<";
  main;
fi

unset_everything;

exit;
