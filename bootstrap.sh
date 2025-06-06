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
# Determine if sudo is needed, and set SUDO variable accordingly
#
set_sudo_prefix() {
  if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
  else
    if ! command -v sudo &>/dev/null; then
      echo "sudo is required but not installed" >&2
      exit 1
    fi
    SUDO="sudo"
  fi
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

GIT_REPONAME="thowdev"

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
# === Preparation functions ===
#
#
# ------------------------------------------------------------------------------
# Prepare MacOS
#
prepare_macos() {
    printf "################################################################################\n"
    printf "# %-20s : %s\n" "Operating System" "${OSTYPE} / ${OS} (${ARCH})"

    if [[ "$OSTYPE" == "darwin"* ]] && ! xcode-select -p &>/dev/null; then
        printf "# %-50s \n" "  - Installing Xcode Command Line Tools ..."
        echo "Installing Xcode Command Line Tools ..."
        ${SUDO} xcode-select --install
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
    fi

    if [[ "$OSTYPE" == "darwin"* ]] && ! command -v brew &>/dev/null; then
        printf "# %-50s \n" "  - Installing Homebrew ..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    printf "# %-50s \n" "  - brew install -q bash curl make ..."
    brew install -q bash curl make
}

# ------------------------------------------------------------------------------
# Prepare Fedora
#
prepare_fedora() {
    printf "################################################################################"
    printf "# %-20s : %s\n" "Operating System" "${OSTYPE}"
    printf "# %-20s : %s\n" "Operating System" "${OS}"
    printf "# %-20s : %s\n" "Arch" "${ARCH}"

    ${SUDO} dnf install -y --allowerasing bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare RHEL/UBI
#
prepare_ubi() {
    printf "################################################################################"
    printf "# %-20s : %s\n" "Operating System" "${OSTYPE}"
    printf "# %-20s : %s\n" "Operating System" "${OS}"
    printf "# %-20s : %s\n" "Arch" "${ARCH}"

    ${SUDO} dnf install -y --allowerasing bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare SLES/LEAP
#
prepare_leap() {
    printf "################################################################################"
    printf "# %-20s : %s\n" "Operating System" "${OSTYPE}"
    printf "# %-20s : %s\n" "Operating System" "${OS}"
    printf "# %-20s : %s\n" "Arch" "${ARCH}"

    ${SUDO} zypper install -y bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare Ubuntu
#
prepare_ubuntu() {
    printf "################################################################################"
    printf "# %-20s : %s\n" "Operating System" "${OSTYPE}"
    printf "# %-20s : %s\n" "Operating System" "${OS}"
    printf "# %-20s : %s\n" "Arch" "${ARCH}"

    ${SUDO} apt update && apt install -y bash curl gzip make tar
}

prepare_system() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        prepare_macos
        return
    fi

    if [[ -f /etc/os-release ]]; then
        . /etc/os-release

        case "$ID" in
            ubuntu|debian)
                prepare_ubuntu
                ;;
            fedora)
                prepare_fedora
                ;;
            rhel|centos)
                prepare_ubi
                ;;
            opensuse-leap|sles|suse)
                prepare_leap
                ;;
            *)
                echo "Unsupported Linux distribution: $ID"
                exit 1
                ;;
        esac
    else
        echo "Cannot detect Linux distribution (missing /etc/os-release)"
        exit 1
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
        echo "# Installing make ..."
        if command -v apt &>/dev/null; then
            ${SUDO} apt update && ${SUDO} apt install -y build-essential
        elif command -v dnf &>/dev/null; then
            ${SUDO} dnf install -y make
        elif command -v zypper &>/dev/null; then
            ${SUDO} zypper --quiet install -y make
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
    chezmoi init --apply ${GIT_REPONAME}
}

# ------------------------------------------------------------------------------
# Call make setup from dotfiles repo
#
run_make_setup() {
    echo "################################################################################"
    echo "# Run chezmoi setup ..."
    make -C "$XDG_DATA_HOME/chezmoi" --silent || true
}


################################################################################
# === Main ===
#
#
# ------------------------------------------------------------------------------
# Ordered installation/setup steps (order is important):
#
set_sudo_prefix

prepare_system

install_make

install_chezmoi

init_dotfiles
run_make_setup

echo "Bootstrap complete!"
