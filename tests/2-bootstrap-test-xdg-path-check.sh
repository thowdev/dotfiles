#!/usr/bin/env bash
set -euo pipefail

echo "[xdg-path-check] Verifying XDG Base Directory structure ..."

: "${XDG_CONFIG_HOME:=$HOME/.config}"
: "${XDG_DATA_HOME:=$HOME/.local/share}"
: "${XDG_CACHE_HOME:=$HOME/.cache}"

for dir in "$XDG_CONFIG_HOME" "$XDG_CACHE_HOME" "$XDG_DATA_HOME"; do
  if [[ ! -d "$dir" ]]; then
    echo "Missing XDG directory: $dir"
    exit 1
  fi
  echo "Exists: $dir"
done
