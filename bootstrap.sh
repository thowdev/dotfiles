#!/usr/bin/env bash

set -euo pipefail

################################################################################
# === Helper Functions ===
#
#
# ------------------------------------------------------------------------------
#
get_arch() {
  local arch="$(uname -m)"

  case "$arch" in
    x86_64) echo "amd64" ;;
    aarch64 | arm64) echo "arm64" ;;
    s390x) echo "s390x" ;;
    *) echo "Unsupported architecture: $arch" >&2; exit 1 ;;
  esac
}

# ------------------------------------------------------------------------------
#
get_os() {
  local os="$(uname | tr '[:upper:]' '[:lower:]')"

  case "$os" in
    linux | darwin) echo "$os" ;;
    *) echo "Unsupported OS: $os" >&2; exit 1 ;;
  esac
}

# ------------------------------------------------------------------------------
#
version_lt() {
  [ "$1" = "$2" ] && return 1 || [ "$(printf '%s\n' "$1" "$2" | sort -V | head -n1)" != "$2" ]
}

################################################################################
# === VARIABLES ===
#
#
ARCH="$(get_arch)"
OS="$(get_os)"

CHEZMOI_VERSION="2.62.5"
CHEZMOI_FILE="chezmoi_${CHEZMOI_VERSION}"
CHEZMOI_URL="https://github.com/twpayne/chezmoi/releases/download/v${CHEZMOI_VERSION}"
CHEZMOI_INSTALL_URL="get.chezmoi.io"

HLB_PATH="${HOME}/.local/bin"
export PATH="${HLB_PATH}:$PATH"


################################################################################
# === XDG Base Directory Setup ===
#
#
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

################################################################################
# === Bootstrap functions ===
#
#
# ------------------------------------------------------------------------------
# Install Homebrew on MacOS
#
install_brew() {
    if [[ "$OSTYPE" == "darwin"* ]] && ! command -v brew &>/dev/null; then
        echo "################################################################################"
        echo "# Installing Homebrew (macOS) ..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
}

# ------------------------------------------------------------------------------
# Install chezmoi
#
install_chezmoi() {
    echo "################################################################################"
    echo "# Installing chezmoi (via official ${CHEZMOI_INSTALL_URL}) ..."
    sh -c "$(curl -fsLS ${CHEZMOI_INSTALL_URL})" -- -b "${HLB_PATH}"
}

# ------------------------------------------------------------------------------
# Install GNU make
#
install_make() {
    local MAKE_GNUBIN_DIR="/opt/homebrew/opt/make/libexec/gnubin"

    if [[ -d "${MAKE_GNUBIN_DIR}" ]]; then
        export PATH="${MAKE_GNUBIN_DIR}:$PATH"
    fi

    if ! command -v make &>/dev/null || version_lt "$(make --version | head -n1 | awk '{print $3}')" "4.0"; then
        echo "################################################################################"
        echo "# Installing make..."
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y build-essential
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y make
        elif command -v zypper &>/dev/null; then
            sudo zypper install -y make
        elif command -v brew &>/dev/null; then
            brew install -q make
            if [[ -d "${MAKE_GNUBIN_DIR}" ]]; then
                export PATH="${MAKE_GNUBIN_DIR}:$PATH"
            fi
        else
            echo "No supported package manager for make."; exit 1
        fi
    fi
}

# ------------------------------------------------------------------------------
# Initialize my dotfiles
#
init_dotfiles() {
    echo "################################################################################"
    echo "# Initializing chezmoi ..."
    chezmoi init --apply thowdev --quiet
}

# ------------------------------------------------------------------------------
# Call make setup from dotfiles repo
#
run_make_setup() {
    echo "################################################################################"
    echo "# Run chezmoi setup ..."
    make -C "$XDG_DATA_HOME/chezmoi" --silent || true
}

# ------------------------------------------------------------------------------
# Ordered installation (order is important):
#
install_brew
install_make
install_chezmoi
init_dotfiles
run_make_setup

echo "Bootstrap complete!"
