#!/bin/sh

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep ".php\{0,1\}$")
RULESET=./phpcs.xml
PASS=true

if [[ "$STAGED_FILES" = "" ]]; then
  exit 0
fi

# Check if phpcs is installed
which ./vendor/bin/phpcs &> /dev/null
if [[ "$?" == 1 ]]; then
  echo "\t\033[41mPlease install PHPCS\033[0m"
  exit 1
fi

echo "\n--- PHP CodeSniffer ---\n"

for FILE in $STAGED_FILES
do
  ./vendor/bin/phpcbf -q "$FILE" $RULESET > /dev/null
  ./vendor/bin/phpcs -q "$FILE" $RULESET > /dev/null

  if [[ "$?" == 0 ]]; then
    echo "\t\033[32mPassed: $FILE\033[0m"
  else
    echo "\t\033[41mFailed: $FILE\033[0m"
    PASS=false
  fi
done

if ! $PASS; then
  echo "\n\033[41mCOMMIT FAILED\033[0m\nRun: \033[42m./vendor/bin/phpcs . code-quality/phpcs.xml\033[0m from root to see the CodeSniffer errors.\n"
  exit 1
else
  git add .
  echo "\n\033[42mCOMMIT SUCCEEDED\033[0m\n"
fi

exit $?
