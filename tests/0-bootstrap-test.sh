#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

test_dir="$(dirname "$0")"

# Extract filename (strip path)
script_name="${0##*/}"

# Remove leading 0- prefix and .sh suffix
base_name="${script_name#0-}"
base_name="${base_name%.sh}"

echo "Running $test_dir/$0 (BST)..."

mapfile -t test_files < <(find "$test_dir" -maxdepth 1 -type f -name '*-${base_name}-*.sh' | sort)

for test_script in "${test_files[@]}"; do
    echo "Running $test_script..."
    bash "$test_script"
done

echo "All tests passed"


