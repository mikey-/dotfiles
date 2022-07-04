#!/usr/bin/env bash

# regular tree options
# alias tree='tree -axCFNQ --dirsfirst --noreport --sort=name --';

# pretty colours using lolcat

#alias ptree='tree -axCFNQ --noreport --sort=mtime | lolcat';

# OG_TREE="$(command -v tree)";

alias tree='tree -axCFNQ --noreport --sort=mtime';

function pretty_tree () {
  printf "%s" "$(tree -axCFNQ --noreport --sort=mtime "$@" --)" | lolcat --truecolor;
}

alias ptree='pretty_tree';

# pretty colours using lolcat but no indentation
alias mtree=\
'printf "%s" "$(tree -axCFNi --dirsfirst --noreport --si --sort=name --);"';

# Print HTML Representation of dir list
alias htree='tree -axCFNS --dirsfirst --noreport --si --sort=name -H';

# Print JSON Representation of dir list
alias jtree='tree -axCFNSJ --dirsfirst --noreport --si --sort=name --';

alias atree='tree -L 2 ${AWS_ENV_DIR}/.aws';

alias show_trees='alias | grep -E "[s|a|p|m|h|j]?tree"';
