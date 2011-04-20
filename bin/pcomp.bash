#!/bin/bash
# pcomp.bash
# Provides limited, unreliable programmatic completion of partial bash command lines.
# Usage:
# Source this file from a completion-enabled bash instance.

# $1: The partial command line to be completed.
#     This can't be split into arguments
#     because that would ignore consecutive spaces.
#function pcomplete {

function debug {
  local v;
  for v in "$@"; do
    echo -n "$v=\"${!v}\";  ";
  done;
  echo;
}

function complete_any {
  local partial="$1";
  local words=( $1 );
  local func;
  debug partial 'words[@]' func
  if [[ ${words[0]} ]]; then
    if [[ ${#words[@]} -gt 1 ]] || [[ "$partial" =~ ^.*[[:space:]]$ ]]; then
      if func="$(complete_func_name "${words[0]}")"; then
        complete_func "$func" "$partial";
      else
        complete_filenames;
      fi;
    else
      complete_commands;
    fi;
  else
    complete_empty;
  fi;
}

function complete_empty {
  # TODO: finish this
  debug complete_empty
  echo;
}

function complete_filenames {
  # TODO: finish this
  debug complete_filenames
  echo;
}

function complete_commands {
  # TODO: finish this
  debug complete_commands
  echo;
}

# Outputs the name of the completion function for the command $1.
# Requires: grep, sed
function complete_func_name {
  complete -p | grep '.*-F \w\+.*\<'"$1"'$' | sed 's/.*-F \(\w\+\).*/\1/';
}

# complete_func FUNC PARTIAL
# Complete via the function registered for the passed partial command line.
function complete_func {
  local func="$1"; shift;
  local COMP_WORDS;
  if ! [[ ${COMP_WORDS[@]} ]]; then
    COMP_WORDS=($1);
  fi;
  local COMP_LINE="${COMP_LINE:-"$1"}";
  local COMP_COUNT=${COMP_COUNT:-$((${#1} + 1))};
  # TODO: Figure out if both of these are needed.
  # http://stackoverflow.com/questions/3520936/#answer-3640096 uses COMP_COUNT
  # http://groups.google.com/group/vim_use/browse_thread/thread/fbdd5fec3554225f#msg_5debae0528c9ffc1
  #   uses COMP_POINT.
  # COMP_POINT seems to work for _aptitude, _apt_get where COMP_COUNT doesn't.
  local COMP_POINT=${COMP_POINT:-$COMP_COUNT};
  local COMP_CWORD=${COMP_CWORD:-${#COMP_WORDS[@]}};
  # Complete for the next word if the fragment ends in a space.
  if ! [[ $COMP_LINE =~ ^.*[[:space:]]$ ]]; then
    let COMP_CWORD-=1;
  fi;
  debug 'COMP_WORDS[@]' COMP_LINE COMP_COUNT COMP_POINT COMP_CWORD
  $func;
  local IFS=$'\n'; echo "${COMPREPLY[*]}";
}
