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
# Check and compare version
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

CHEZMOI_INSTALL_URL="get.chezmoi.io"

GIT_REPONAME="thowdev"

################################################################################
# === XDG Base Directory Setup ===
#
#

HLB_DIR="${HOME}/.local/bin"
export PATH="${HLB_DIR}:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

mkdir -p ${XDG_CONFIG_HOME} ${XDG_DATA_HOME} ${XDG_CACHE_HOME} ${HLB_DIR}

################################################################################
# === Preparation functions ===
#
#
# ------------------------------------------------------------------------------
# Prepare MacOS
#
prepare_macos() {
    printf "################################################################################\n"
    printf "# MacOS (%s) preparation on %s:\n" "$(sw_vers -productVersion)" "${OSTYPE}/${OS} (${ARCH})"

    if ! xcode-select -p &>/dev/null; then
        ${SUDO} xcode-select --install
        until xcode-select -p &>/dev/null; do
            sleep 5
        done
    fi

    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    printf "#\n"
    printf "# %s\n" "> brew install --quiet bash curl make"
    brew install --quiet bash curl make
}

# ------------------------------------------------------------------------------
# Prepare Fedora
#
prepare_fedora() {
    printf "################################################################################\n"
    printf "# Fedora (%s) preparation on %s:\n" "$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')" "${OSTYPE}/${OS} (${ARCH})"
    printf "#\n"

    printf "# %s\n" "> ${SUDO} dnf install -y --allowerasing bash curl gzip make tar"
    ${SUDO} dnf install -y --allowerasing bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare RHEL/UBI
#
prepare_ubi() {
    printf "################################################################################\n"
    printf "# UBI (%s) preparation on %s:\n" "$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')" "${OSTYPE}/${OS} (${ARCH})"
    printf "#\n"

    printf "# %s\n" "> ${SUDO} dnf install -y --allowerasing bash curl gzip make tar"
    ${SUDO} dnf install -y --allowerasing bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare SLES/LEAP
#
prepare_leap() {
    printf "################################################################################\n"
    printf "# LEAP (%s) preparation on %s:\n" "$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')" "${OSTYPE}/${OS} (${ARCH})"
    printf "#\n"

    printf "# %s\n" "> ${SUDO} zypper install -y bash curl gzip make tar"
    ${SUDO} zypper install -y bash curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare Ubuntu
#
prepare_ubuntu() {
    printf "################################################################################\n"
    printf "# Ubuntu (%s) preparation on %s:\n" "$(grep '^VERSION_ID=' /etc/os-release | cut -d= -f2 | tr -d '"')" "${OSTYPE}/${OS} (${ARCH})"
    printf "#\n"

    printf "# %s\n" "> ${SUDO} apt-get update && ${SUDO} apt-get install -y bash curl gzip make tar"
    ${SUDO} apt-get update && ${SUDO} apt-get install -y bash build-essential curl gzip make tar
}

# ------------------------------------------------------------------------------
# Prepare System
#
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
    sh -c "$(curl -fsLS ${CHEZMOI_INSTALL_URL})" -- -b "${HLB_DIR}"
    ${SUDO} chmod +x "${HLB_DIR}/chezmoi"
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

install_chezmoi

init_dotfiles
run_make_setup

echo "Bootstrapping "dotfiles" completed!"
