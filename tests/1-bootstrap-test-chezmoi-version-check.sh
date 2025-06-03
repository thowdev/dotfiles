#!/usr/bin/env bash
set -euo pipefail

CHEZMOI_BIN="${HOME}/.local/bin/chezmoi"
EXP_CHEZMOI_VERSION="v2.62.6"

printf "#    %s\n" "Check chezmoi installation and version ..."

if [ -x "${CHEZMOI_BIN}" ]; then
    printf "#        %s\n" "> ${CHEZMOI_BIN} exists"
else
    printf "# ERROR: %s\n" "${CHEZMOI_BIN} not found"
    exit 1
fi

CHEZMOI_VERSION="$("${CHEZMOI_BIN}" --version | grep -o 'v[0-9.]\+')"

if [[ "${CHEZMOI_VERSION}" == "${EXP_CHEZMOI_VERSION}" ]]; then
    printf "#        %s\n" "> Detected chezmoi version (${CHEZMOI_VERSION}) matches expected version: ${EXP_CHEZMOI_VERSION}"
else
    printf "# ERROR: %s\n" "Detected chezmoi version (${CHEZMOI_VERSION}) does not match expected version: ${EXP_CHEZMOI_VERSION}"
    exit 1
fi
