#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

test_dir="$(dirname "$0")"

echo "Running tests/bootstrap-test.sh (BST)..."

for test_script in $test_dir/*-BST-*.sh; do
    [ -e "$test_script" ] || continue  # Skip if no matches
    echo "Running $test_script..."
    bash "$test_script"
done

echo "All tests passed"


