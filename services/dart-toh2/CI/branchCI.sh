echo "[INFO] -> Running actions for branch $SERVICE..."

# Get dependencies, fail shell on bad exit
pub get
failOnBadExit $?
echo

# Set bulid platform for Server/VM
# DART_BUILD_PLATFORM="vm"
# Set bulid platform for Web/UI
DART_BUILD_PLATFORM="chrome"

# Run Server/VM tests and tee output to report, fail shell on bad exit
# pub run test -p $DART_BUILD_PLATFORM --reporter expanded |
# Run Web/UI tests and tee output to report, fail shell on bad exit
pub run build_runner test --fail-on-severe -- -p $DART_BUILD_PLATFORM --reporter expanded |
tee $BASE"/services/artifacts/"$SERVICE"_branch_results.out"
failOnBadExit $?
echo

# All done!
echo "[INFO] -> Finished!"
