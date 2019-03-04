#!/usr/bin/env bash

# we need to load helpers outside of everything else
# because they're used by most other functions
# shellcheck disable=SC1090
source "${HOME}"/.dot.function.d/helpers.sh

source_dotfiles;
