#!/bin/bash

#####
# Type Analysis

# ANA="dartanalyzer --enable_type_checks --fatal-type-errors --extended-exit-code --type-checks-for-inferred-types --incremental"
ANA="dartanalyzer"

echo
echo "Type Analysis, running dartanalyzer..."

EXITSTATUS=0
WARNINGS=0
FAILURES=0
PASSING=0

####
# test files one at a time
#
for file in web/lib/*.dart
do
  results=`$ANA $file 2>&1`
  exit_code=$?
  if [ $exit_code -eq 2 ]; then
  	let FAILURES++
    EXITSTATUS=1
    echo "$results"
    echo "$file: FAILURE."
  elif [ $exit_code -eq 1 ]; then
  	let WARNINGS++
	echo "$results"
    echo "$file: WARNING."
  elif [ $exit_code -eq 0 ]; then
  	let PASSING++
	echo "$file: Passed analysis."
  else
	echo "$file: exit code = $exit_code"
fi
done