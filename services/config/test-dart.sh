#!/bin/sh

# Grab working directory
BASE=$(pwd)
# Grab test directories
TESTS=$(ls $BASE/services/ | grep go-)

# Create artifacts directory
mkdir $BASE/services/artifacts

# For each test directory
for DARTTEST in $TESTS ; do
  # Move into test directory
  cd $BASE/services/$DARTTEST
  # Get dependencies
  pub get
  # Run tests and tee output to report
  pub run test | tee $BASE"/services/artifacts/"$DARTTEST"_results.out"
done
