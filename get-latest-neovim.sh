#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
readonly DOWNLOAD_URL_BASE="https://github.com/neovim/neovim/releases/latest/download"
readonly BASE_NAME="nvim-linux-x86_64"
readonly TARBALL_NAME="$BASE_NAME.tar.gz"
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
cleanup() {
  printf "\n"
  msg_info "Cleaning up temporary files..."
  rm -rf "$TMP_DIR" 2>/dev/null || true

  # Clean up backup directories older than 7 days
  find "$HOME/.local" -name "nvim-linux-x86_64.backup.*" -type d -mtime +7 -exec rm -rf {} \; 2>/dev/null || true
}
trap cleanup EXIT
cd "$TMP_DIR"

msg_step "Downloading latest Neovim tar file..."
curl -fLO "${DOWNLOAD_URL_BASE}/${TARBALL_NAME}"

msg_step "Extracting $TARBALL_NAME..."
tar xzf "$TARBALL_NAME"

msg_step "Removing old Neovim installation (if it exists)..."
# Check if nvim is currently running
if pgrep -f "nvim" >/dev/null; then
  msg_err "Neovim is currently running. Please close all nvim instances and try again."
fi

# Backup existing installation if it exists
if [ -d "$INSTALL_DIR" ]; then
  msg_info "Backing up existing installation..."
  BACKUP_DIR="${INSTALL_DIR}.backup.$(date +%s)"
  mv "$INSTALL_DIR" "$BACKUP_DIR" 2>/dev/null || rm -rf "$INSTALL_DIR" 2>/dev/null || true
fi

# Remove symlink with force
rm -f "$SYMLINK_PATH" 2>/dev/null || true

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
