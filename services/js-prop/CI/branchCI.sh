echo "[INFO] -> Running actions for branch $SERVICE..."

# Get dependencies, fail shell on bad exit
npm i
failOnBadExit $?

# Run tests and tee output to report, fail shell on bad exit
npm test |
tee $BASE"/services/artifacts/"$SERVICE"_branch_results.out"
failOnBadExit $?

# All done!
echo "[INFO] -> Finished!"
