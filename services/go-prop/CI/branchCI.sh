

echo "[INFO] -> Running actions for branch $SERVICE..."

GO_TEST_TYPE="Unit"

# Run tests and tee output to reporter
go test ./... \
  -covermode=count \
  -coverprofile="$BASE/services/artifacts/"$SERVICE"_branch_coverage.out" \
  -run $GO_TEST_TYPE \
  -bench . \
  -count 5
failOnBadExit $?

  # Create HTML coverage report in artifacts directory
go tool cover \
  -html="$BASE/services/artifacts/"$SERVICE"_branch_coverage.out" \
  -o=$BASE"/services/artifacts/"$SERVICE"_branch_coverage.html"\

# All done!
echo "[INFO] -> Finished!"
