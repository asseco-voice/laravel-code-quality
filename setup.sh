#!/bin/sh
# Code quality setup script, enforcing same code quality rules for all team members
# Running as composer post-install script

# Directory from which the script is called (to know in which folder to install code quality tools)
CALLER_DIR=$PWD
BASEDIR=$(dirname "$0")

composer install

echo "Installing git hooks from '${BASEDIR}/.githooks/*' to '${CALLER_DIR}/.git/hooks/'"
cp -R $BASEDIR/.githooks/* $CALLER_DIR/.git/hooks
