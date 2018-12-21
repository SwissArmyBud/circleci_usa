#!/bin/sh

BASE=$(pwd)
TESTS=$(ls $BASE/services/ | grep sol-)
for SOLTEST in $TESTS ; do
  cp ./services/config/sol-config.json ./services/$SOLTEST/package.json
  cp ./services/config/truffle-config.js ./services/$SOLTEST/truffle.js
  cd ./services/$SOLTEST
  truffle test
  rm $BASE/services/$SOLTEST/package.json
  rm $BASE/services/$SOLTEST/truffle.js
  cd $BASE
done
