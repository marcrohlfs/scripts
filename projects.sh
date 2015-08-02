#!/bin/sh

##### Manage projects #####



### Check passed arguments and initialse variables for command execution ###

# Set help and usage texts.
BASENAME=$( basename $0)
USAGE="${BASENAME} [-h]"
USAGE_TEXT="usage: ${USAGE}"
MAN_TEXT="
NAME
  ${BASENAME} -- manages projects.

SYNOPSIS
  ${USAGE}

DESCRIPTION
  Manages projects on a development workstation.

  The options are as follows:

  -h
      Print this help.
"

# Pass the option arguments to variables.
while getopts "h" OPTFLAG; do
  case "${OPTFLAG}" in

    # Main (command) arguments
    h) PRINT_HELP=true;;

    # Unknown arguments
    ?) echo "${USAGE_TEXT}" >&2
       exit 1;;
  esac
done

# Ensure that exactly one of the main command arguments is specified.
NUM_COMMAND_ARGS=0
[[ -n ${PRINT_HELP} ]] && NUM_COMMAND_ARGS=$( expr ${NUM_COMMAND_ARGS} + 1 )
if [[ "${NUM_COMMAND_ARGS}" != "1" ]]; then
  echo "Please specify exactly one of the arguments [-h]" >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
fi

# Print the help text.
if [ "${PRINT_HELP}" == "true" ]; then
  echo "${MAN_TEXT}"
  exit 0
fi
