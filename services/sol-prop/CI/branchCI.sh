echo "[INFO] -> Running actions for branch $SERVICE, finished!"

# Get dependencies, fail shell on bad exit
npm i
failOnBadExit $?

# Run tests and tee output to report, fail shell on bad exit
truffle test |
tee $BASE"/services/artifacts/"$SERVICE"_branch_results.out"
failOnBadExit $?
