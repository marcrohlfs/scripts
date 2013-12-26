#!/bin/sh

##### Find JAR files that contain a specified entry #####



### Check the passed arguments and set the variables for the command execution ###

# Set help and usage texts.
BASENAME=$( basename $0)
USAGE="${BASENAME} {-c class-name | -s search-string} [-d directory] [-e extensions]"
USAGE_TEXT="usage: ${USAGE}"
MAN_TEXT="
NAME
  ${BASENAME} -- finds JAR files containing a specified entry

SYNOPSIS
  ${USAGE}

DESCRIPTION
  Recursively searches a directory for JAR or other archive files and lists those
  containing the requested entry.

  -c class-name
      The name of a class entry contained by the archives to be found - can be either the
      simple class name or the fully qualified class name.

  -d directory
      The directory containing the archives to be found. If the directory option is not
      set, the current working directory will be used.

  -e extensions
      The extensions of the archive files to be checked. If none is provided, only
      archives with the extension '.jar' will be checked. Multiple extensions must be
      passed comma-separated.

  -h
      Print this help (ignoring the other passed arguments).

  -s search-string
      The substring of an entry contained by the archives to be found.
"

# Pass the option arguments to variables.
while getopts "c:d:e:hs:" OPTFLAG; do
  case "${OPTFLAG}" in
    c) CLASS=${OPTARG};;
    d) DIRECTORY=${OPTARG};;
    h) PRINT_HELP=true;;
    e) EXTENSIONS=${OPTARG};;
    s) SEARCH_STRING=${OPTARG};;

    ?) echo "${USAGE_TEXT}" >&2
       exit 1;;
  esac
done

# Print the help text.
if [ "${PRINT_HELP}" == "true" ]; then
  echo "${MAN_TEXT}"
  exit 0
fi

# Any search criteria must be defined.
if [[ -n "${SEARCH_STRING}" && -n "${CLASS}" ]]; then
  echo "Please specify only one of the search options: search string or class name" >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
elif [[ -z "${SEARCH_STRING}" && -z "${CLASS}" ]]; then
  echo "Please specify one of the search options: search string or class name" >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
elif [ -n "${CLASS}" ]; then
  SEARCH_STRING="$( echo "${CLASS}" | sed 's:\.:/:g' ).class"
fi

# Check the specified directory or use the current working directory.
if [ -z "${DIRECTORY}" ]; then
  DIRECTORY=$( pwd )
elif [ ! -d "${DIRECTORY}" ]; then
  echo "The given directory doesn't exist." >&2
  echo "${USAGE_TEXT}" >&2
  exit 1
fi

# If not extensions are specified, use the default extension.
EXTENSIONS_FIND_OPTIONS=""
if [ -z "${EXTENSIONS}" ]; then
  EXTENSIONS="jar"
fi

# Pass the specified extensions to a set of options for the find command.
EXTENSIONS_FIND_OPTIONS=""
if [ -z "${EXTENSIONS}" ]; then
  EXTENSIONS="jar"
fi
for EXTENSION in $( echo ${EXTENSIONS} | sed 's/,/ /g' ); do
  if [ -n "${EXTENSIONS_FIND_OPTIONS}" ]; then
    EXTENSIONS_FIND_OPTIONS="${EXTENSIONS_FIND_OPTIONS} -o"
  fi
  EXTENSIONS_FIND_OPTIONS="${EXTENSIONS_FIND_OPTIONS} -name *.${EXTENSION}"
done



### Do the search ###

for ARCHIVE in $( find ${DIRECTORY} ${EXTENSIONS_FIND_OPTIONS} ); do
  if [ -n "$( unzip -l ${ARCHIVE} | grep "${SEARCH_STRING}" )" ]; then
    echo ${ARCHIVE}
  fi
done
