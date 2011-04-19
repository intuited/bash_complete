#!/bin/bash
# pcomp.bash
# Provides limited, unreliable programmatic completion of partial bash command lines.
# Source this file from a completion-enabled bash instance to use.

# $1: The partial command line to be completed.
#     This can't be split into arguments
#     because that would ignore consecutive spaces.
#function pcomplete {

function debug {
  for v in "$@"; do
    echo -n "$v=\"${!v}\";  ";
  done;
  echo;
}

# Complete via the function registered for the passed command.
function complete_func {
  local COMP_WORDS;
  if ! [[ ${COMP_WORDS[@]} ]]; then
    COMP_WORDS=($1);
  fi;
  local COMP_LINE="${COMP_LINE:-"$1"}";
  local COMP_COUNT=${COMP_COUNT:-$((${#1} + 1))};
  local COMP_CWORD=${COMP_CWORD:-${#COMP_WORDS[@]}};
  # Complete for the next word if the fragment ends in a space.
  if ! [[ $COMP_LINE =~ ^.*[[:space:]]$ ]]; then
    let COMP_CWORD-=1;
  fi;
  debug 'COMP_WORDS[@]' COMP_LINE COMP_COUNT COMP_CWORD
  _git;
  local IFS=$'\n'; echo "${COMPREPLY[*]}";
}
