#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
readonly DOWNLOAD_URL_BASE="https://github.com/neovim/neovim/releases/latest/download"
readonly BASE_NAME="nvim-linux-x86_64"
readonly TARBALL_NAME="$BASE_NAME.tar.gz"
readonly CHECKSUM_FILE_NAME="shasum.txt"
readonly BIN_DIR="$HOME/.local/bin"
readonly INSTALL_DIR="$HOME/.local/$BASE_NAME"
readonly SYMLINK_PATH="$BIN_DIR/nvim"

# --- Colors and Formatting ---
readonly C_RESET='\033[0m'
readonly C_RED='\033[0;31m'
readonly C_GREEN='\033[0;32m'
readonly C_YELLOW='\033[0;33m'
readonly C_CYAN='\033[0;36m'
readonly C_BOLD='\033[1m'

# --- Message Functions ---
msg_step() {
  printf "${C_CYAN}➤ %s${C_RESET}\n" "$1"
  sleep 0.25
}

msg_ok() {
  printf "${C_GREEN}✔ %s${C_RESET}\n" "$1"
}

msg_info() {
  printf "${C_YELLOW}ℹ %s${C_RESET}\n" "$1"
}

msg_err() {
  printf "${C_RED}✖ ERROR: %s${C_RESET}\n" "$1" >&2
  exit 1
}

msg_header() {
  printf "\n${C_BOLD}${C_CYAN}===== %s =====${C_RESET}\n\n" "$1"
}

# --- Main Script Logic ---

command -v curl >/dev/null 2>&1 ||
  msg_err "curl is not installed. Please install it to continue."
command -v sha256sum >/dev/null 2>&1 ||
  msg_err "sha256sum is not installed. Please install it to continue."

TMP_DIR=$(mktemp -d)
trap 'printf "\n"; msg_info "Cleaning up temporary files..."; rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

msg_step "Downloading latest Neovim and the checksum file..."
curl -fLO "${DOWNLOAD_URL_BASE}/${TARBALL_NAME}"
curl -fLO "${DOWNLOAD_URL_BASE}/${CHECKSUM_FILE_NAME}"

msg_step "Verifying file integrity with SHA256 checksum..."
EXPECTED_CHECKSUM=$(grep "$TARBALL_NAME" "$CHECKSUM_FILE_NAME" | awk '{print $1}')
ACTUAL_CHECKSUM=$(sha256sum "$TARBALL_NAME" | awk '{print $1}')

if [[ "$EXPECTED_CHECKSUM" == "$ACTUAL_CHECKSUM" ]]; then
  msg_ok "Checksum verification successful."
else
  msg_err "Checksum verification failed!
  Expected: $EXPECTED_CHECKSUM
  Got:      $ACTUAL_CHECKSUM"
fi

msg_step "Extracting $TARBALL_NAME..."
tar xzf "$TARBALL_NAME"

msg_step "Removing old Neovim installation (if it exists)..."
rm -rf "$INSTALL_DIR"
rm -f "$SYMLINK_PATH"

msg_step "Installing Neovim to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mv "$BASE_NAME/"* "$INSTALL_DIR/"

if [ -L "$SYMLINK_PATH" ] && [ "$(readlink -f "$SYMLINK_PATH")" == "$INSTALL_DIR" ]; then
  msg_info "Symbolic link is already up to date. Skipping."
else
  msg_step "Creating/updating symbolic link at $SYMLINK_PATH..."
  rm -f "$SYMLINK_PATH"
  ln -s "$INSTALL_DIR/bin/nvim" "$SYMLINK_PATH"
fi

printf "\n"
msg_ok "Neovim has been successfully updated!"
msg_info "Make sure '$BIN_DIR' is in your shell's PATH."
printf "\n"
"$SYMLINK_PATH" --version
printf "\n"
