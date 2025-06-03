#!/usr/bin/env bash
set -euo pipefail

printf "#    %s\n" "Verify XDG Base Directory structure ..."

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

XDG_DIRS=(
    "$XDG_CONFIG_HOME"
    "$XDG_CACHE_HOME"
    "$XDG_DATA_HOME"
)

for DIR in "${XDG_DIRS[@]}"; do
    if [[ ! -d "${DIR}" ]]; then
        printf "# ERROR: %s\n" "> Missing XDG directory: $DIR"
        exit 1
    fi
    printf "#        %s\n" "> Exists: $DIR"
done
