#!/bin/sh

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep ".php\{0,1\}$")
PASS=true

CODE_QUALITY_PATH=./../code-quality
PHP_CODE_SNIFFER_RULESET=${CODE_QUALITY_PATH}/phpcs.xml
PHP_CS_FIXER_RULESET=${CODE_QUALITY_PATH}/phpcsfixer.xml
PHP_MESS_DETECTOR_RULESET=${CODE_QUALITY_PATH}/phpmd.xml

# Colors
Black="\033[0;30m"
Red="\033[0;31m"
Green="\033[0;32m"
Yellow="\033[0;33m"
Blue="\033[0;34m"
Purple="\033[0;35m"
Cyan="\033[0;36m"
White="\033[0;37m"

# Background
OnBlack="\033[40m"
OnRed="\033[41m"
OnGreen="\033[42m"
OnYellow="\033[43m"
OnBlue="\033[44m"
OnPurple="\033[45m"
OnCyan="\033[46m"
OnWhite="\033[47m"

# Combinations
WhiteOnRed="\033[0;37m\033[41m"
BlackOnGreen="\033[0;30m\033[42m"
WhiteOnBlue="\033[0;37m\033[44m"

NoColor='\033[0m'

# No sense in scanning complete codebase. Scanning only changed PHP files
if [[ "$STAGED_FILES" = "" ]]; then
  echo -e "No staged PHP files. Skipping pre-commit hook...\n"
  exit 0
fi

# Check if phpcs is installed
which ./vendor/bin/phpcs &> /dev/null
if [[ "$?" == 1 ]]; then
  echo -e "${WhiteOnRed}Please install PHPCS${NoColor}\n"
  exit 1
fi

echo -e "\n--- PHP CodeSniffer ---\n"

for FILE in $STAGED_FILES
do
  ./vendor/bin/phpcbf --standard=$PHP_CODE_SNIFFER_RULESET -q "$FILE" > /dev/null
  ./vendor/bin/phpcs --basepath=. --standard=$PHP_CODE_SNIFFER_RULESET -v "$FILE"

  if [[ "$?" == 0 ]]; then
    echo -e "${BlackOnGreen}Passed: $FILE${NoColor}\n"
  else
    echo -e "${WhiteOnRed}Failed: $FILE${NoColor}\n"
    PASS=false
  fi
done

if ! $PASS; then
  echo -e "${WhiteOnRed}COMMIT FAILED"
  echo -e "Run: ${WhiteOnBlue}./vendor/bin/phpcs . ../code-quality/phpcs.xml${WhiteOnRed} from root to see CodeSniffer errors.${NoColor}\n"
  exit 1
else
  git add .
  echo -e "${BlackOnGreen}COMMIT SUCCEEDED${NoColor}\n"
fi

exit $?
