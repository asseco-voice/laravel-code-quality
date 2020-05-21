# Code quality standard

This repository is meant to be a single place for PHP related quality 
standards when it comes to committing code from any PHP microservice
to repository. Its main purpose is creating [git hooks](https://githooks.com/) 
which would catch any pre-commit action and see whether code is written 
according to agreed standards. If it fails, commit will not be made. 

Naming conventions in this document:

- **SERVICE** is used to describe a repository, microservice, external 
service and similar. Codebase which needs to use this repository to comply
to given coding standards
- **CQS** is this repository. Short for **C**ode **Q**uality **S**tandard

CQS is a dependency, **NOT** a standalone service. Automated installation
is implemented as a part of [chassis](http://git/asseco-hr-voice/evil/chassis)
however you are free to install it as a separate dependency

## Installation

Given the fact that most of the codebase is behind Asseco VPN and 
on GitLab repositories, simple ``composer require`` will not suffice
here. 

Inside SERVICE ``composer.json`` you will need to:

- List out code quality repository path

```
"repositories": [
    {
        "type": "vcs",
        "url": "http://git/asseco-hr-voice/evil/code-quality"
    }
],
```

- Include code quality as a required dependency:

```
"require": {
    "asseco-voice/code-quality": "dev-master"
},
```

- Disable secure http (until our git server starts supporting
https):

```
"config": {
    "secure-http": false
},
```

You can now safely run ``composer install`` and code quality will install.

After a successful installation you can 

1. call ``setup.sh`` script with the one of three flags:

    - **-t** install real time monitoring dependencies (NPM packages + gulp file)
    - **-g** install githooks to a directory specified by -d flag, or to a default 
    directory (see -d option)
    - **-d** specify directory root path where githooks should be installed 
    (defaults to directory from which the script is called).  I.e. provided 
    root directory '/project' will install githooks to '/project/.git/hooks'
    If -d option is specified, -g is automatically implied."

2. `setup.sh` will install composer dependencies to get required binaries
as well as copy Git hooks from `CQS/.githooks` to `SERVICE/.git/hooks` 
directory. 

3. At this point any action that is covered with Git hooks will be 
in place for a given SERVICE. 

If you'd like to automate this process to some extent, jump to 
[Automating installation](#automating-installation) section

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

## IDE support

To have PHP code sniffer & mess detector tools integrated within your 
IDE and available in every project instead of setting it up for every
project, it is recommended that you clone the CQS repository at the same 
directory level as a SERVICE:

```
|
|--- code-quality
|--- service1
|--- service2
```
After that point your IDE to ``phpcs.xml`` as a ruleset for PHP code
sniffer, and ``phpmd.xml`` for mess detector ruleset.

Link for [PHPStorm quality tools specifics](https://www.jetbrains.com/help/phpstorm/php-code-quality-tools.html).

## Usage & testing

To test the Git hook script without committing anything to the repo
you can simply run for example `bash SERVICE/.git/hooks/pre-commit.sh`.

Notice that the script will run only for PHP files that are staged 
with `git add` command. 

# Quality checks

## PHP code sniffer

https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties


## PHP Mess detector

https://phpmd.org/rules/index.html
