#!/usr/bin/env bash

function link_dotfiles () {

  ln -fns ${DEFAULT_DOTFILE_DIR}/.aws ${DOTFILE_DIR}/.aws
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gem ${DOTFILE_DIR}/.gem
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gvm ${DOTFILE_DIR}/.gvm
  ln -fns ${DEFAULT_DOTFILE_DIR}/.npm ${DOTFILE_DIR}/.npm
  ln -fns ${DEFAULT_DOTFILE_DIR}/.nvm ${DOTFILE_DIR}/.nvm
  ln -fns ${DEFAULT_DOTFILE_DIR}/.rvm ${DOTFILE_DIR}/.rvm
  ln -fns ${DEFAULT_DOTFILE_DIR}/.vim ${DOTFILE_DIR}/.vim
  ln -fns ${DEFAULT_DOTFILE_DIR}/.ssh ${DOTFILE_DIR}/.ssh
  ln -fns ${DEFAULT_DOTFILE_DIR}/.atom ${DOTFILE_DIR}/.atom
  ln -fns ${DEFAULT_DOTFILE_DIR}/.mume ${DOTFILE_DIR}/.mume
  ln -fns ${DEFAULT_DOTFILE_DIR}/.cargo ${DOTFILE_DIR}/.cargo
  ln -fns ${DEFAULT_DOTFILE_DIR}/.julia ${DOTFILE_DIR}/.julia
  ln -fns ${DEFAULT_DOTFILE_DIR}/.local ${DOTFILE_DIR}/.local
  ln -fns ${DEFAULT_DOTFILE_DIR}/.npmrc ${DOTFILE_DIR}/.npmrc
  ln -fns ${DEFAULT_DOTFILE_DIR}/.pyenv ${DOTFILE_DIR}/.pyenv
  ln -fns ${DEFAULT_DOTFILE_DIR}/.vimrc ${DOTFILE_DIR}/.vimrc
  ln -fns ${DEFAULT_DOTFILE_DIR}/.bundle ${DOTFILE_DIR}/.bundle
  ln -fns ${DEFAULT_DOTFILE_DIR}/.config ${DOTFILE_DIR}/.config
  ln -fns ${DEFAULT_DOTFILE_DIR}/.docker ${DOTFILE_DIR}/.docker
  ln -fns ${DEFAULT_DOTFILE_DIR}/.httpie ${DOTFILE_DIR}/.httpie
  ln -fns ${DEFAULT_DOTFILE_DIR}/.path.d ${DOTFILE_DIR}/.path.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/.condarc ${DOTFILE_DIR}/.condarc
  ln -fns ${DEFAULT_DOTFILE_DIR}/.dotfile ${DOTFILE_DIR}/.dotfile
  ln -fns ${DEFAULT_DOTFILE_DIR}/.ipython ${DOTFILE_DIR}/.ipython
  ln -fns ${DEFAULT_DOTFILE_DIR}/.jupyter ${DOTFILE_DIR}/.jupyter
  ln -fns ${DEFAULT_DOTFILE_DIR}/.lesshst ${DOTFILE_DIR}/.lesshst
  ln -fns ${DEFAULT_DOTFILE_DIR}/.alias.d ${DOTFILE_DIR}/.alias.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/.config.d ${DOTFILE_DIR}/.config.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/.export.d ${DOTFILE_DIR}/.export.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/Brewfile ${DOTFILE_DIR}/Brewfile
  ln -fns ${DEFAULT_DOTFILE_DIR}/.pygments ${DOTFILE_DIR}/.pygments
  ln -fns ${DEFAULT_DOTFILE_DIR}/.script.d ${DOTFILE_DIR}/.script.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/.dotignore ${DOTFILE_DIR}/.dotignore
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gitconfig ${DOTFILE_DIR}/.gitconfig
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gitignore ${DOTFILE_DIR}/.gitignore
  ln -fns ${DEFAULT_DOTFILE_DIR}/.project ${DOTFILE_DIR}/.project
  ln -fns ${DEFAULT_DOTFILE_DIR}/.function.d ${DOTFILE_DIR}/.function.d
  ln -fns ${DEFAULT_DOTFILE_DIR}/.platformio ${DOTFILE_DIR}/.platformio
  ln -fns ${DEFAULT_DOTFILE_DIR}/.subversion ${DOTFILE_DIR}/.subversion
  ln -fns ${DEFAULT_DOTFILE_DIR}/.ruby-version ${DOTFILE_DIR}/.ruby-version
  ln -fns ${DEFAULT_DOTFILE_DIR}/.bash_profile ${DOTFILE_DIR}/.bash_profile
  ln -fns ${DEFAULT_DOTFILE_DIR}/.wakatime.cfg ${DOTFILE_DIR}/.wakatime.cfg
  ln -fns ${DEFAULT_DOTFILE_DIR}/.ProjectFile ${DOTFILE_DIR}/.ProjectFile
  ln -fns ${DEFAULT_DOTFILE_DIR}/.hgignore_global ${DOTFILE_DIR}/.hgignore_global
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gitCommitMessage ${DOTFILE_DIR}/.gitCommitMessage
  ln -fns ${DEFAULT_DOTFILE_DIR}/.gitignore_global ${DOTFILE_DIR}/.gitignore_global
  ln -fns ${DEFAULT_DOTFILE_DIR}/.ipynb_checkpoints ${DOTFILE_DIR}/.ipynb_checkpoints
  ln -fns ${DEFAULT_DOTFILE_DIR}/.mikey.itermcolors ${DOTFILE_DIR}/.mikey.itermcolors
  ln -fns ${DEFAULT_DOTFILE_DIR}/.iterm.profile.json ${DOTFILE_DIR}/.iterm.profile.json
  ln -fns ${DEFAULT_DOTFILE_DIR}/.terminal.mikey.terminal ${DOTFILE_DIR}/.terminal.mikey.terminal
  ln -fns ${DEFAULT_DOTFILE_DIR}/.iterm2_shell_integration.bash ${DOTFILE_DIR}/.iterm2_shell_integration.bash
  return 0;
}
