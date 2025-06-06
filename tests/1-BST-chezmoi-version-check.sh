#!/usr/bin/env bash
set -euo pipefail

CHEZMOI_BIN="${HOME}/.local/bin/chezmoi"

echo "Check chezmoi installation and version ..."

if [ -x "${CHEZMOI_BIN}" ]; then
  echo "${CHEZMOI_BIN} exists"
else
  echo "${CHEZMOI_BIN} not found"
  exit 1
fi

CHEZMOI_VERSION="$("${CHEZMOI_BIN}" --version | grep -o 'v[0-9.]\+')"
echo "Detected chezmoi version: ${CHEZMOI_VERSION}"

if [[ "${CHEZMOI_VERSION}" == "v2.62.5" ]]; then
  echo "Matches expected version: v2.62.5"
else
  echo "Does not match expected version: v2.62.5"
  exit 1
fi
