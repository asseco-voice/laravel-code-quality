#!/bin/sh

STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep ".php\{0,1\}$")
STAGED_FILES_COMMA_SEPARATED=$(git diff --cached --name-only --diff-filter=ACM | grep ".php\{0,1\}$" | paste -sd "," -)

CODE_QUALITY_PATH=./../../code-quality
VENDOR_PATH=${CODE_QUALITY_PATH}/vendor

PHP_CODE_SNIFFER_PATH=${VENDOR_PATH}/bin/phpcs
PHP_CODE_SNIFFER_BEAUTIFIER_PATH=${VENDOR_PATH}/bin/phpcbf
PHP_CODE_SNIFFER_RULESET=${CODE_QUALITY_PATH}/phpcs.xml

PHP_MESS_DETECTOR_PATH=${VENDOR_PATH}/bin/phpmd
PHP_MESS_DETECTOR_RULESET=${CODE_QUALITY_PATH}/phpmd.xml

# Color codes
WhiteOnRed="\033[0;37m\033[41m"
BlackOnGreen="\033[0;30m\033[42m"
WhiteOnBlue="\033[0;37m\033[44m"
NoColor='\033[0m'

# No sense in scanning a complete codebase. Scanning only changed PHP files.
if [[ "$STAGED_FILES" = "" ]]; then
  echo -e "No staged PHP files. Skipping pre-commit hook...\n"
  exit 0
fi

echo -e "========================="
echo -e "PHP code sniffer check..."
echo -e "=========================\n"
# Check if phpcs is installed
which $PHP_CODE_SNIFFER_PATH &> /dev/null
if [[ "$?" == 1 ]]; then
  echo -e "${WhiteOnRed}PHPCS not installed, please install it to proceed.${NoColor}\n"
  exit 1
fi

# Fix what is fixable first (phpcbf) then run phpcs
$PHP_CODE_SNIFFER_BEAUTIFIER_PATH --standard=$PHP_CODE_SNIFFER_RULESET -q $STAGED_FILES > /dev/null
# Hide warnings; Show relative path in reports; Use our standard
$PHP_CODE_SNIFFER_PATH --warning-severity=0 --basepath=. --standard=$PHP_CODE_SNIFFER_RULESET $STAGED_FILES

if [[ "$?" != 0 ]]; then
  echo -e "${WhiteOnRed}COMMIT FAILED because of PHP code sniffer, check output for possible fixes.${NoColor}\n"
  echo -e "To see per-file error, please run this command within the project root:"
  echo -e "\t${WhiteOnBlue}$PHP_CODE_SNIFFER_PATH --standard=$PHP_CODE_SNIFFER_RULESET -v path/to/file${NoColor}\n"
  exit 1
fi
echo -e "${BlackOnGreen}Done.${NoColor}\n"



echo -e "=========================="
echo -e "PHP mess detector check..."
echo -e "==========================\n"
# Check if phpcs is installed

which $PHP_MESS_DETECTOR_PATH &> /dev/null
if [[ "$?" == 1 ]]; then
  echo -e "${WhiteOnRed}PHPMD not installed, please install it to proceed.${NoColor}\n"
  exit 1
fi

$PHP_MESS_DETECTOR_PATH $STAGED_FILES_COMMA_SEPARATED ansi $PHP_MESS_DETECTOR_RULESET

if [[ "$?" != 0 ]]; then
  echo -e "${WhiteOnRed}COMMIT FAILED because of PHP mess detector, check output for possible fixes.${NoColor}"
  echo -e "To see per-file error, please run this command within the project root:"
  echo -e "\t${WhiteOnBlue}$PHP_MESS_DETECTOR_PATH path/to/file ansi $PHP_MESS_DETECTOR_RULESET${NoColor}\n"
  exit 1
fi
echo -e "${BlackOnGreen}Done.${NoColor}\n"




git add .
echo -e "${BlackOnGreen}COMMIT SUCCEEDED${NoColor}\n"
exit $?
