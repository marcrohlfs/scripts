#!/bin/sh

##### Launch Mac Terminal for current project #####



### Terminal Settings ###

# The (initial) working directory
pushd $( dirname $0 ) > /dev/null
PROJECT_WORKING_DIR=$( pwd -P )
popd > /dev/null

# Look for Terminal profile.
CHECK_DIR=${PROJECT_WORKING_DIR}
while [ -n "${CHECK_DIR}" ]; do
  PROJECT_PROFILE_FILE=$( find ${CHECK_DIR} -maxdepth 1 -mindepth 1 -name '*.terminal' | grep -m 1 ${CHECK_DIR} )
  if [ -n "${PROJECT_PROFILE_FILE}" ]; then
    PROJECT_PROFILE_DIR=${CHECK_DIR}
    CHECK_DIR=""
  else
    CHECK_DIR="${CHECK_DIR%/*}"
  fi
done



### Launch Terminal ###

# Some project settings can only be sourced properly when the working directory is known at Terminal start. To achieve
# this, the (inital) working directory can be provided as file argument when using the 'open' command to start the Mac
# Terminal. An exported Mac Terminal profile can be applied to a new Terminal window in the same way. Unfortunately, it
# is not possible to apply both, working directory and profile at the same time to the same window. If this is needed,
# the profile file is provided as file argument and the working directory is written to a temporary file, that will be
# read by  the scripts that are sourced on Terminal start.

if [ -n "${PROJECT_PROFILE_FILE}" ]; then
  # Write the working directory to a temporary file.
  echo "${PROJECT_WORKING_DIR}" > ${PROJECTS_TMP_PWD_FILE}
  # Before opening the Terminal, change to the directory where the profile file resides.
  # This should avoid redundant pofile imports when using the profile for multiple projects.
  cd ${PROJECT_PROFILE_DIR}
  open -a Terminal "${PROJECT_PROFILE_FILE}"
else
  open -a Terminal "${PROJECT_WORKING_DIR}"
fi
