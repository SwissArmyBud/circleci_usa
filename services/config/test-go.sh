#!/bin/sh

# Grab working directory
BASE=$(pwd)
# Grab test directories
TESTS=$(ls $BASE/services/ | grep go-)

mkdir $BASE/services/artifacts

# For each test directory
for GOTEST in $TESTS ; do
  # Move into test directory
  cd $BASE/services/$GOTEST
  # Run tests and tee output to reporter
  go test ./... \
    -covermode=count \
    -coverprofile="coverage.out" \
    -run "Unit" \
    -bench . \
    -count 5
  # Create HTML coverage report in artifacts directory
  go tool cover \
    -html="coverage.out" \
    -o=$BASE"/services/artifacts/"$GOTEST"_coverage.html"
  # Move coverage record to artifacts directory
  cp coverage.out $BASE"/services/artifacts/"$GOTEST"_coverage.out"
done
