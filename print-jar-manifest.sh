#!/bin/sh

##### Print the contents of a JARs' manifest file #####



### Check the passed arguments and set the variables for the command execution ###

# Set help and usage texts.
BASENAME=$( basename $0)
USAGE="${BASENAME} -f jar-file"
USAGE_TEXT="usage: ${USAGE}"
MAN_TEXT="
NAME
  ${BASENAME} -- prints the contents of a JARs' manifest file.

SYNOPSIS
  ${USAGE}

DESCRIPTION
  Extracts the contents of a Java archives' manifest file (META-INF/MANIFEST.MF) and
  writes them to the STDOUT.

  -f jar-file
      The Java archive file containing the manifest file to be printed.

  -h
      Print this help (ignoring the other passed arguments).
"

# Pass the option arguments to variables.
while getopts "f:h" OPTFLAG; do
  case "${OPTFLAG}" in
    f) JAR_FILE=${OPTARG};;
    h) PRINT_HELP=true;;

    ?) echo "${USAGE_TEXT}" >&2
       exit 1;;
  esac
done

# Print the help text.
if [ "${PRINT_HELP}" == "true" ]; then
  echo "${MAN_TEXT}"
  exit 0
fi

# An existing JAR file must be defined.
if [ ! -f "${JAR_FILE}" ]; then
  echo "Please specify an existing JAR file." >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
fi

# Define a working directory.
WORK_DIR_CMD=/tmp/$( echo "${BASENAME}" | sed 's/\./_/g' )
WORK_DIR_JAR=${WORK_DIR_CMD}/$( basename "${JAR_FILE}" | sed 's/\./_/g' )



### Extract and print the manifest ###

# Extract the manifest to the working directory.
mkdir -p ${WORK_DIR_JAR}
unzip -qod ${WORK_DIR_JAR} ${JAR_FILE} META-INF/MANIFEST.MF

# Print the manifest.
cat ${WORK_DIR_JAR}/META-INF/MANIFEST.MF

# Clean up the working directory.
rm -rf ${WORK_DIR_CMD}
