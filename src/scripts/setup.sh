#!/usr/bin/env bash

<<README

Code quality setup script, enforcing same code quality rules for all team members.
Flags are explained within the script menu.

README

BASEDIR=$(dirname "$0")

help() {
  echo "Code quality setup script options:"
  echo "   -h    show this text"
  echo "   -d    specify directory root path where githooks should be installed (defaults to directory from which the script is called)."
  echo "         I.e. provided root directory '/project' will install githooks to '/project/.git/hooks'"
  echo "         If -d option is specified, -g is automatically implied."
}

if [ $# -eq 0 ]; then
    echo "No arguments provided. Please see the options below..."
    help
    exit 1;
fi

DIRECTORY=''

while getopts 'gd:h' flag; do
  case "${flag}" in
    d) DIRECTORY="${OPTARG}" ;;
    *) help
       exit 0 ;;
  esac
done

# Taking -d flag parameter (path) or automatically fetching directory from which the script is called
# (to know in which folder to install code quality tools) if no argument is provided
CALLER_DIR=${DIRECTORY:-${PWD}}

if [ ! -d ${CALLER_DIR} ]; then
  echo "Directory ${CALLER_DIR} doesn't exist, please provide a valid path..."
  exit 1
fi

composer install -d ${BASEDIR}

echo "Installing git hooks from '${BASEDIR}/.githooks/*' to '${CALLER_DIR}/.git/hooks/'"
cp -R ${BASEDIR}/.githooks/* ${CALLER_DIR}/.git/hooks

echo "Code quality setup done."
