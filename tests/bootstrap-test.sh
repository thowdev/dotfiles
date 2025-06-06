#!/usr/bin/env bash
set -euo pipefail

echo "Running tests/bootstrap-test.sh (BST)..."

for test_script in "$(dirname "$0")"/*-BST-*.sh; do
    [ -e "$test_script" ] || continue  # Skip if no matches
    echo "Running $test_script..."
    bash "$test_script"
done

echo "All tests passed"


