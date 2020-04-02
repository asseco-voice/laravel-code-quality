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

# No sense in scanning a complete codebase. Scanning only changed PHP files.
if [[ "$STAGED_FILES" = "" ]]; then
  echo -e "No staged PHP files. Skipping pre-commit hook...\n"
  exit 0
fi



echo -e "================================="
echo -e "Checking for PHP syntax errors..."
echo -e "=================================\n"
# Doesn't check for undefined variables/functions
SYNTAX_FAILED=()
for FILE in $STAGED_FILES
do
  php -lf $FILE > /dev/null
  if [[ "$?" != 0 ]]; then
    SYNTAX_FAILED+="\t$FILE\n"
    PASS=false
  fi
done

if ! $PASS; then
  echo -e "${WhiteOnRed}COMMIT FAILED because of syntax errors in the following files:${NoColor}"
  for FILE in $SYNTAX_FAILED
  do
    echo -e "$FILE"
  done
  echo -e "Exiting..."
  exit 1
fi
echo -e "${BlackOnGreen}Done.${NoColor}\n"



echo -e "========================="
echo -e "PHP code sniffer check..."
echo -e "=========================\n"
# Check if phpcs is installed
which ./vendor/bin/phpcs &> /dev/null
if [[ "$?" == 1 ]]; then
  echo -e "${WhiteOnRed}PHPCS not installed, please install it to proceed.${NoColor}\n"
  exit 1
fi

for FILE in $STAGED_FILES
do
  # Fix what is fixable first (phpcbf) then run phpcs
  ./vendor/bin/phpcbf --standard=$PHP_CODE_SNIFFER_RULESET -q "$FILE" > /dev/null
  # Hide warnings; Show relative path in reports; Use our standard
  ./vendor/bin/phpcs --warning-severity=0 --basepath=. --standard=$PHP_CODE_SNIFFER_RULESET "$FILE"

  if [[ "$?" != 0 ]]; then
    echo -e "${WhiteOnRed}Failed:${NoColor} ${WhiteOnBlue}$FILE${NoColor}\n"
    PASS=false
  fi
done

if ! $PASS; then
  echo -e "${WhiteOnRed}COMMIT FAILED because of PHP code sniffer fails.${NoColor}"
  echo -e "To see per-file error, please run this command within the project root:"
  echo -e "\t${WhiteOnBlue}./vendor/bin/phpcs --standard=../code-quality/phpcs.xml -v path/to/file${NoColor}\n"
  exit 1
fi
echo -e "${BlackOnGreen}Done.${NoColor}\n"



git add .
echo -e "${BlackOnGreen}COMMIT SUCCEEDED${NoColor}\n"
exit $?
