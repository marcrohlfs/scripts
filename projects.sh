#!/bin/sh

##### Manage projects #####



### Check passed arguments and initialse variables for command execution ###

# Define the base directory, where all managed projects are stored.
[[ -z ${PROJECTS_BASEDIR} ]] && PROJECTS_BASEDIR=${HOME}/projects

# Set help and usage texts.
BASENAME=$( basename $0)
USAGE="${BASENAME} [-c project-name | -h] [-b basedir]"
USAGE_TEXT="usage: ${USAGE}"
MAN_TEXT="
NAME
  ${BASENAME} -- manages projects.

SYNOPSIS
  ${USAGE}

DESCRIPTION
  Manages projects on a development workstation. Each project is stored in a
  directory below '~/projects'.

  The options are as follows:

  -b basedir
      Overwrites the base directory, where all managed projects are stored. The
      default base directory is '~/projects'. It can also be overwritten using
      the environment variable 'PROJECTS_BASEDIR'.

  -c project-name
      Create a new project with the given name. This option will create a
      directory with the given project name as sub directory of '~/projects'.

  -h
      Print this help.
"

# Pass the option arguments to variables.
while getopts "b:c:h" OPTFLAG; do
  case "${OPTFLAG}" in

    # Main (command) arguments
    c) NEW_PROJECT=${OPTARG};;
    h) PRINT_HELP=true;;

    # Overwritable arguments
    b) PROJECTS_BASEDIR=${OPTARG};;

    # Unknown arguments
    ?) echo "${USAGE_TEXT}" >&2
       exit 1;;
  esac
done

# Ensure that exactly one of the main command arguments is specified.
NUM_COMMAND_ARGS=0
[[ -n ${NEW_PROJECT} ]] && NUM_COMMAND_ARGS=$( expr ${NUM_COMMAND_ARGS} + 1 )
[[ -n ${PRINT_HELP} ]] && NUM_COMMAND_ARGS=$( expr ${NUM_COMMAND_ARGS} + 1 )
if [[ "${NUM_COMMAND_ARGS}" != "1" ]]; then
  echo "Please specify exactly one of the arguments [-c | -h]" >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
fi

# Print the help text.
if [ "${PRINT_HELP}" == "true" ]; then
  echo "${MAN_TEXT}"
  exit 0
fi



### Create new project ###
if [ -n "${NEW_PROJECT}" ]; then

  # Create the project directory
  NEW_PROJECT_DIR=${PROJECTS_BASEDIR}/${NEW_PROJECT}
  if [ ! -e "${NEW_PROJECT_DIR}" ]; then
    mkdir -p "${NEW_PROJECT_DIR}"
    echo "Created project directory ${NEW_PROJECT_DIR}"
  elif [ ! -d "${NEW_PROJECT_DIR}" ]; then
    echo "${PROJECTS_BASEDIR}/${NEW_PROJECT} already exists but isn't a directory" >&2
    exit 1
  fi

fi
