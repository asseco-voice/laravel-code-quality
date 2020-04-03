#!/bin/sh
# Code quality setup script, enforcing same code quality rules for all team members

# Taking first parameter (path) or automatically fetching directory from which the script is called
# (to know in which folder to install code quality tools) if no argument is provided
CALLER_DIR=${1:-$PWD}
BASEDIR=$(dirname "$0")

if [ ! -d $CALLER_DIR ]
then
  echo "Directory ${CALLER_DIR} doesn't exist, please provide a valid path..."
  exit 1
fi

composer install -d ${BASEDIR}

echo "Installing git hooks from '${BASEDIR}/.githooks/*' to '${CALLER_DIR}/.git/hooks/'"
cp -R $BASEDIR/.githooks/* $CALLER_DIR/.git/hooks
