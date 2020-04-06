#!/bin/sh
# Code quality setup script, enforcing same code quality rules for all team members

BASEDIR=$(dirname "$0")

help() {
  echo "Code quality setup script options:"
  echo "   -h    show this text"
  echo "   -t    include testing option (will install NPM && gulp script to enable real time monitoring for TDD)"
  echo "   -g    install githooks to a directory specified by -d flag, or to a default directory (see -d option)"
  echo "   -d    specify directory root path where githooks should be installed (defaults to directory from which the script is called)."
  echo "         I.e. provided root directory '/project' will install githooks to '/project/.git/hooks'"
  echo "         If -d option is specified, -g is automatically implied."
}

if [ $# -eq 0 ]; then
    echo "No arguments provided. Please see the options below..."
    help
    exit 1;
fi

TESTING_FLAG=false
GITHOOKS_FLAG=false
DIRECTORY=''

while getopts 'tgd:h' flag; do
  case "${flag}" in
    t) TESTING_FLAG=true ;;
    g) GITHOOKS_FLAG=true ;;
    d) GITHOOKS_FLAG=true; DIRECTORY="${OPTARG}" ;;
    *) help
       exit 0 ;;
  esac
done

if [ "$GITHOOKS_FLAG" = true ]; then
  # Taking -d flag parameter (path) or automatically fetching directory from which the script is called
  # (to know in which folder to install code quality tools) if no argument is provided
  CALLER_DIR=${DIRECTORY:-$PWD}

  if [ ! -d $CALLER_DIR ]; then
    echo "Directory ${CALLER_DIR} doesn't exist, please provide a valid path..."
    exit 1
  fi

  composer install -d ${BASEDIR}

  echo "Installing git hooks from '${BASEDIR}/.githooks/*' to '${CALLER_DIR}/.git/hooks/'"
  cp -R $BASEDIR/.githooks/* $CALLER_DIR/.git/hooks
fi

if [ "$TESTING_FLAG" = true ]; then

  which node &> /dev/null
  if [[ "$?" == 1 ]]; then
    echo "Node (NPM) is not installed, please install it to proceed."
    exit 1
  fi

  #npm install --prefix $BASEDIR gulp-cli gulp-phpunit gulp-notify
  #cd $BASEDIR
  #npm link gulp
  #cd -
  $BASEDIR/node_modules/.bin/gulp --gulpfile=$BASEDIR/gulpfile.js watch

fi

echo "Done and done."
