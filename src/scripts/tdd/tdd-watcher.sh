#!/usr/bin/env bash

BASEDIR=$(dirname "$0")

help() {
  echo "Test watcher options:"
  echo "   -h    show this text"
  echo "   -r    repository path (defaults to pwd of calling directory)"
  echo "   -d    phpunit directory to test (defaults to complete /tests directory)"
  echo "   -f    phpunit file to test (defaults to /tests directory). Takes precedence before -d flag"
}

REPOSITORY=''
DIRECTORY=''
FILE=''


# Script will trigger installation only if node_modules folder doesn't exist
if [ ! -d "${BASEDIR}/node_modules" ]; then
  which node &> /dev/null
  if [[ "$?" == 1 ]]; then
    echo "NPM is not installed, please install it to proceed."
    exit 1
  fi

  echo "NPM is installed, but dependencies are missing. Installing..."
  npm install --prefix ${BASEDIR}
  cd ${BASEDIR}
  npm link gulp
  cd -
fi


while getopts 'hr:d:f:' flag; do
  case "${flag}" in
    r) REPOSITORY="${OPTARG}" ;;
    d) DIRECTORY="${OPTARG}" ;;
    f) FILE="${OPTARG}" ;;
    *) help
       exit 0 ;;
  esac
done

[[ ! -z ${REPOSITORY} ]] && REPOSITORY_FLAG="-r ${REPOSITORY}" || REPOSITORY_FLAG="-r ${PWD}"
[[ ! -z ${DIRECTORY} ]] && DIRECTORY_FLAG="-d ${DIRECTORY}" || DIRECTORY_FLAG=""
[[ ! -z ${FILE} ]] && FILE_FLAG="-f ${FILE}" || FILE_FLAG=""

echo "Starting watcher..."

${BASEDIR}/node_modules/.bin/gulp --gulpfile=${BASEDIR}/gulpfile.js ${REPOSITORY_FLAG}
