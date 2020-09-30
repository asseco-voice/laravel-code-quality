# Code quality standard

This repository is meant to be a single place for PHP related quality 
standards when it comes to committing code from any Laravel (micro) service
to repository. Its main purpose is creating [git hooks](https://githooks.com/) 
which would catch any pre-commit action and see whether code is written 
according to agreed standards. If it fails, commit will not be made. 

Naming conventions in this document:

- **SERVICE** is used to describe a repository, microservice, external 
service and similar. Codebase which needs to use this repository to comply
to given coding standards.
- **CQS** is this repository. Short for Code Quality Standard.

## Installation

Require the package with ``composer require asseco-voice/laravel-code-quality``.
Service provider for Laravel will be installed automatically.

After a successful installation you have 2 new Artisan commands available:

- ``voice:git-hooks`` - will install git-hooks by copying 
from `CQS/.githooks` to `SERVICE/.git/hooks` directory. 
- ``voice:tdd`` - will install real time monitoring dependencies if not already 
present (NPM packages + gulp file), and depending on the flags you provided (explained
within the command itself) will run real time monitoring for test folders as well as
files under the ``App`` folder to enable automatic tests running with notification flag
whether test succeeded or not. This is useful in a way that you don't have to switch
between IDE and terminal back and forth to see if tests passed. **Don't run in Docker,
or you will not receive notifications.** 

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

To test the git hook script without committing anything to the repo
you can simply run for example `bash SERVICE/.git/hooks/pre-commit.sh`.

Notice that the script will run only for PHP files that are staged 
with `git add` command. 

# Quality checks

## PHP code sniffer

https://github.com/squizlabs/PHP_CodeSniffer/wiki/Customisable-Sniff-Properties

## PHP Mess detector

https://phpmd.org/rules/index.html
