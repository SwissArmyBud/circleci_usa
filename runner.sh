#!/bin/bash

# Grab working directory
BASE=$(pwd)

# Create artifacts for CircleCI recovery
# SEE @ https://circleci.com/docs/2.0/artifacts/
mkdir $BASE/services/artifacts

# Pipe fails "from the left" - tee must not capture errors in test stream
set -o pipefail

# Function to test exit codes and throw or continue
function failOnBadExit() {
    if [ $1 -ne 0 ]; then
        echo "[FAIL] -> Command failed with exit code $1."
        exit $1
    fi
}

# Grab current language precursor from CircleCI YAML injection
# https://circleci.com/docs/2.0/env-vars/
echo "[INFO] -> Current language prefix is: $CI_LANGUAGE_PREFIX"
# Run language specific setup steps
case "$CI_LANGUAGE_PREFIX" in
  dart)
    # Add dart path to shell, SDK PATH not included when loaded from APT
    PATH="$PATH:/usr/lib/dart/bin"
    ;;
  go)
    ;;
  js)
    ;;
  sol)
    # Truffle has to be installed globally by sudo
    sudo npm i -g truffle
    ;;
esac

# Grab service directory by language prefix
SERVICES=$(ls $BASE/services/ | grep "$CI_LANGUAGE_PREFIX-")

# For each service directory
for SERVICE in $SERVICES ; do

  # Move into test directory
  cd $BASE/services/$SERVICE

  # Run pre-ci scripting for project dependant vars, etc
  echo "[INFO] -> Running prerunCI source for project: $SERVICE"
  source "./CI/prerunCI.sh"

  # Optionally, include some filtered actions
  if [[ -n "$CI_SERVICE_FILTER" ]] # Loaded from CircleCI project settings
    then
      for FILTER in $CI_SERVICE_FILTER ; do
        if [ $SERVICE == $FILTER ]
          then
          echo "[INFO] -> Found $SERVICE as $FILTER in \$CI_TEST_FILTER"
          # Run filter-defined actions for the project
          echo "[INFO] -> Running filterCI source for project: $SERVICE"
          source "./CI/filterCI.sh"
        fi
      done
    else
      echo "[WARN] -> No \$CI_SERVICE_FILTER variable found in ENV!"
  fi

  # Do certian things for the current project branch
  if [[ $CIRCLE_BRANCH == $SERVICE ]] # From CI env vars for each build
    then
      echo "[INFO] -> Found $SERVICE in \$CIRCLE_BRANCH"
      # Run branch-defined actions for the project
      echo "[INFO] -> Running branchCI source for project: $SERVICE"
      source "./CI/branchCI.sh"
    else
      # Skip other projects
      echo "[WARN] -> This project is being ignored by CI as unlinked to branch!"
  fi

  # Run post-ci scripting for project dependant vars, etc
  echo "[INFO] -> Running postrunCI source for project: $SERVICE"
  source "./CI/postrunCI.sh"

done
