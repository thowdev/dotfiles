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

COSIGN_VERSION="2.5.0"
COSIGN_FILE="cosign-${OS}-${ARCH}"
COSIGN_URL="https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/${COSIGN_FILE}"

PYTHON_VERSION="3.12.3"
PYTHON_DIR="${HOME}/.local/python/${PYTHON_VERSION}"

HLB_PATH="${HOME}/.local/bin"
export PATH="${HLB_PATH}:$PATH"

TMP_DIR="$(mktemp -d)"
TMP_VENV="$(TMP_DIR)/venv"


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
    echo "# Installing chezmoi (with optional Cosign verification) ..."

    echo "#   - Installing via official install script (get.chezmoi.io)..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "${HLB_PATH}"

    echo "#   - Downloading verification files ..."

    curl -fsSL "${CHEZMOI_URL}/${CHEZMOI_FILE}_checksums.txt" -o "${TMP_DIR}/${CHEZMOI_FILE}_checksums.txt"
    curl -fsSL "${CHEZMOI_URL}/${CHEZMOI_FILE}_checksums.txt.sig" -o "${TMP_DIR}/${CHEZMOI_FILE}_checksums.txt.sig"
    curl -fsSL "${CHEZMOI_URL}/chezmoi_cosign.pub" -o "${TMP_DIR}/chezmoi_cosign.pub"

    echo "SHA256 checksums saved at: ${TMP_DIR}/${CHEZMOI_FILE}_checksums.txt"
    echo "Cosign signature saved at: ${TMP_DIR}/${CHEZMOI_FILE}_checksums.txt.sig"
    echo "Cosign public key saved at: ${TMP_DIR}/chezmoi_cosign.pub"
}

# ------------------------------------------------------------------------------
# === Install cosign ===
#
install_cosign() {
    if ! command -v cosign &>/dev/null; then
        echo "################################################################################"
        echo "# Install Cosign ..."

        echo "#  - Download from ${COSIGN_URL} to ${HLB_PATH}/${COSIGN_FILE}"
        curl -fsSL "${COSIGN_URL}" -o "${HLB_PATH}/${COSIGN_FILE}"
        chmod +x "${HLB_PATH}/${COSIGN_FILE}"
        ln -sf  "${HLB_PATH}/${COSIGN_FILE}" "${HLB_PATH}/cosign-${COSIGN_VERSION}"
        ln -sf  "${HLB_PATH}/${COSIGN_FILE}" "${HLB_PATH}/cosign"

        echo "# Verify Cosign ..."

    fi
}

# ------------------------------------------------------------------------------
# Install GNU make
#
install_make() {
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
            brew install make
            if [[ -d "/opt/homebrew/opt/make/libexec/gnubin" ]]; then
                export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
            fi
        else
            echo "No supported package manager for make."; exit 1
        fi
    fi
}

# ------------------------------------------------------------------------------
# Install python
#
install_python() {
    if [[ -x "${PYTHON_DIR}/bin/python3" ]]; then
        echo "Python ${PYTHON_VERSION} already installed at ${PYTHON_DIR}"
        return
    fi

    echo " Installing Python ${PYTHON_VERSION} using python-build..."

    if [[ ! -x "$HOME/.local/bin/python-build" ]]; then
    echo "📥 Downloading python-build..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://raw.githubusercontent.com/pyenv/pyenv/master/plugins/python-build/bin/python-build \
      -o "$HOME/.local/bin/python-build"
    chmod +x "$HOME/.local/bin/python-build"
  fi

  mkdir -p "$install_dir"
  python-build "$version" "$install_dir"

  echo "✅ Python $version installed to $install_dir"
    if ! command -v python3 &>/dev/null; then
        echo "################################################################################"
        echo "# Installing python3 ..."
        if command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y python3 python3-venv python3-pip
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y python3 python3-virtualenv python3-pip
        elif command -v zypper &>/dev/null; then
            sudo zypper install -y python3 python3-pip python3-virtualenv
        elif command -v brew &>/dev/null; then
            brew install make
            if [[ -d "/opt/homebrew/opt/make/libexec/gnubin" ]]; then
                export PATH="/opt/homebrew/opt/make/libexec/gnubin:$PATH"
            fi
        else
            echo "No supported package manager for make."; exit 1
        fi
    fi
}

# ------------------------------------------------------------------------------
# Install The Update Framework (TUF) client
#
install_tuf() {
    python3 -m venv "$TMP_VENV"
source "$TMP_VENV/bin/activate"
pip install --upgrade pip
pip install securesystemslib tuf[tools]
# → Verwende hier die TUF-Tools...
deactivate
rm -rf "$TMP_VENV"


}

# ------------------------------------------------------------------------------
# Initialize my dotfiles
#
init_dotfiles() {
    echo "Initializing chezmoi..."
    chezmoi init --apply
}

# ------------------------------------------------------------------------------
# Initialize my dotfiles
#
run_make_setup() {
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
