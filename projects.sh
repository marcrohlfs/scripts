#!/bin/sh

##### Manage projects #####



### Functions ###

# Confirm dialog for user interactions
# Usage: confirm "Question?"
# Returns: 0 = true, 1 = false
confirm() {
  read -r -p "$1 [y/n] " response
  case $response in
    [yY][eE][sS]|[yY])
      return 0;;
    *)
      return 1;;
  esac
}



### Check passed arguments and initialse variables for command execution ###

# Get the absolute path to the parent directory and the name of this script.
pushd $( dirname $0 ) > /dev/null
BASENAME=$( basename $0)
DIRNAME=$( pwd -P )
popd > /dev/null

# All assets needed by this script are found in a dedicated directory.
ASSETS_DIR=${DIRNAME}/assets/${BASENAME%.*}

# Define the base directory, where all managed projects are stored.
[[ -z ${PROJECTS_BASEDIR} ]] && PROJECTS_BASEDIR=${HOME}/projects

# Set help and usage texts.
USAGE="${BASENAME} [-c project-name | -h] [-b basedir]"
USAGE_TEXT="usage: ${USAGE}"
MAN_TEXT="
NAME
  ${BASENAME} -- manages projects.

SYNOPSIS
  ${USAGE}

DESCRIPTION
  Manages projects on a development workstation. Each project is stored in a
  directory below '~/projects', can define project-specific settings
  (environment variables, aliases, etc.) and has its own history.

  The options are as follows:

  -b basedir
      Overwrites the base directory, where all managed projects are stored. The
      default base directory is '~/projects'. It can also be overwritten using
      the environment variable 'PROJECTS_BASEDIR'.

  -c project-name
      Create a new project with the given name. This option will create a
      directory with the given project name as sub directory of '~/projects' and
      place a '.projectrc' file in the new project directory.

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



### Check prerequisites ###

# The RC file for projects settings initialsation must have been sourced.
# Assumption: It has been sourced, when PROJECTS_RCFILE is defined.
if [ -z ${PROJECTS_RCFILE} ]; then
  echo "Project environments require ${ASSETS_DIR}/rcfile to be sourced."
  if [ "${SHELL}" == $( which zsh ) ]; then
    RCFILE="${HOME}/.zshrc"
  else
    RCFILE="${HOME}/.profile"
  fi
  if confirm "Should 'source ${ASSETS_DIR}/rcfile' be added to ${RCFILE}?"; then
    echo "" >> ${RCFILE}
    echo "# Source the RC file that sets the custom environment for each project." >> ${RCFILE}
    echo "source ${ASSETS_DIR}/rcfile" >> ${RCFILE}
    source ${ASSETS_DIR}/rcfile
    echo "Added and executed 'source ${ASSETS_DIR}/rcfile' to ${RCFILE}"
  else
    echo "Aborting. Please add 'source ${ASSETS_DIR}/rcfile' to Your Terminal startup files!" >&2
    exit 1
  fi
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

  # Create project source script.
  if [ ! -f "${NEW_PROJECT_DIR}/${PROJECTS_RCFILE}" ]; then
    echo "# RC file for project ${NEW_PROJECT}" > "${NEW_PROJECT_DIR}/${PROJECTS_RCFILE}"
    echo "Created project source script ${NEW_PROJECT_DIR}/${PROJECTS_RCFILE}"
  fi

fi
