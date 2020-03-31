#!/bin/sh
# Code quality setup script, enforcing same code quality rules for all team members
# Running as composer post-install script

# Install git hooks locally
cp .githooks/* ./../.git/hooks/*
