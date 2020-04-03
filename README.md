# Code quality standard

This repository is meant to be a single place for PHP related quality 
standards when it comes to committing code from any PHP microservice
to repository. Its main purpose is creating Git hooks which would
catch any pre-commit action and see whether code is written according
to agreed standards. If it fails, commit will not be made. 

Naming conventions in this document:

- **SERVICE** is used to describe a repository, microservice, external 
service and similar. Codebase which needs to use this repository to comply
to given coding standards
- CQS is this repository. Short for **C**ode **Q**uality **S**tandard

## Installation

CQS is NOT to be used as a standalone service.

If you'd like to automate this process to some extent, jump to 
[Automating installation](#automating-installation) section

SERVICE which needs to comply to a set of standards developed here 
MUST do the following to support it:

1. clone the CQS repository at the same directory level as a SERVICE:

    ```
    |
    |--- code-quality
    |--- service1
    |--- service2
    ```

2. Call the CQS `setup.sh` script either from:

    2.1. SERVICE root (paths will be automatically mapped).
    
    2.2. CQS root including a path to SERVICE
    as a first parameter (`setup.sh /path/to/service`).

3. `setup.sh` will install composer dependencies to get required binaries
as well as copy Git hooks (`CQS/.githooks`) to `SERVICE/.git/hooks` 
directory. 

4. At this point any action that is covered with Git hooks will be 
in place for a given SERVICE. 

## Automating installation

In order to somewhat automate the process, you can create a Composer
post-install script within SERVICE. 

For example, create a script called `code-quality-setup.sh` at SERVICE
root which will contain the following: 

```
#!/bin/sh

echo "######### COMPOSER POST INSTALL SCRIPT #########"

# Download/update code quality repo
CODE_QUALITY_DIR="${PWD}/../code-quality"
if [ ! -d $CODE_QUALITY_DIR ]; then
  echo "No code quality repo found at ${CODE_QUALITY_DIR}, cloning the repo one level above"
  git clone http://git/asseco-hr-voice/evil/code-quality.git ../code-quality
else
  echo "Code quality repo found, updating..."
  git -C $CODE_QUALITY_DIR pull
fi

# Code quality entrypoint
bash $CODE_QUALITY_DIR/setup.sh

echo "####### COMPOSER POST INSTALL SCRIPT END #######"
```

This script is effectively downloading/updating CQS repository and running
its entry script `setup.sh` which will install needed Composer dependencies
and update SERVICE Git hooks. 

For this one to work, a prerequisite is to have `git` & `bash` dependencies
installed on your machine/server. 

Once you have this script in place, you need to add a Composer 
post-install script:

```
"scripts": {
    "post-install-cmd": [
        "bash code-quality-setup.sh"
    ]
}
```

Once this is done, upon every `composer install` CQS repository will 
be updated along with required Git hooks. 

## Usage & testing

To test the Git hook script without committing anything to the repo
you can simply run for example `bash SERVICE/.git/hooks/pre-commit.sh`.

Notice that the script will run only for PHP files that are staged 
with `git add` command. 

# Quality checks

## PHP syntax errors

Simple check with PHP inbuilt linter `php -l /path/to/file`.

## PHP code sniffer

https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties


## PHP Mess detector

https://phpmd.org/rules/index.html

## PHP CS fixer

https://cs.symfony.com/
