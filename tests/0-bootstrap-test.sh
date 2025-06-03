#!/usr/bin/env bash

set -euo pipefail
shopt -s nullglob

SCRIPT_NAME="${0##*/}"
TEST_DIR="$(cd "$(dirname "$0")" && pwd)"

# curl case when piping to bash (curl ... | bash)
if [[ "${SCRIPT_NAME}" == "bash" ]]; then
    SCRIPT_NAME="${BST_SCRIPT_NAME}"
    TEST_DIR="$(pwd)/tests"
fi

# Remove leading 0- prefix and .sh suffix
BASE_NAME="${SCRIPT_NAME#0-}"

# Remove .sh suffix
BASE_NAME="${BASE_NAME%.sh}"

echo "################################################################################"
echo "# Start ${TEST_DIR}/${SCRIPT_NAME} (BootStrapTest [BST])..."

mapfile -t TEST_FILES < <(find "${TEST_DIR}" -type f -name "*-${BASE_NAME}-*.sh" | sort)

COUNTER=1
for TEST_SCRIPT in "${TEST_FILES[@]}"; do
    echo "#-------------------------------------------------------------------------------"
    echo "# ${COUNTER}. Running ${TEST_SCRIPT}..."
    bash "${TEST_SCRIPT}"
    ((COUNTER++))
done

echo "All tests passed!"
