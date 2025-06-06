#!/usr/bin/env bash
set -euo pipefail
shopt -s nullglob

test_dir="$(dirname "$0")"

echo "Running $test_dir/$0 (BST)..."

for test_script in $(ls "$test_dir"/*-BST-*.sh | sort); do
    echo "Running $test_script..."
    bash "$test_script"
done

echo "All tests passed"


