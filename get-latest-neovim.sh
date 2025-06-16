#!/usr/bin/env bash

set -e

echo_message() {
  echo "$@"
  sleep 0.25
}

DOWNLOAD_URL_BASE="https://github.com/neovim/neovim/releases/latest/download"
BASE_NAME="nvim-linux-x86_64"
TARBALL_NAME="$BASE_NAME.tar.gz"
CHECKSUM_FILE_NAME="shasum.txt"
BIN_DIR="$HOME/.local/bin"
SYMLINK_PATH="$BIN_DIR/nvim"
INSTALL_DIR="$HOME/.local/$BASE_NAME"

echo_message "Starting Neovim update for the current user..."

TMP_DIR=$(mktemp -d)

trap 'echo "Cleaning up temporary files..."; rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

echo_message "Downloading latest Neovim and the checksum file..."
curl -fLO "${DOWNLOAD_URL_BASE}/${TARBALL_NAME}"
curl -fLO "${DOWNLOAD_URL_BASE}/${CHECKSUM_FILE_NAME}"

echo_message "Verifying file integrity with SHA256 checksum..."

EXPECTED_CHECKSUM=$(grep "$TARBALL_NAME" "$CHECKSUM_FILE_NAME" | awk '{print $1}')
ACTUAL_CHECKSUM=$(sha256sum "$TARBALL_NAME" | awk '{print $1}')

if [[ "$EXPECTED_CHECKSUM" == "$ACTUAL_CHECKSUM" ]]; then
  echo "Checksum verification successful."
else
  echo "
  ERROR: Checksum verification failed!
  Expected: $EXPECTED_CHECKSUM
  Got:      $ACTUAL_CHECKSUM"
  exit 1
fi

echo_message "Extracting $TARBALL_NAME..."
tar xzf "$TARBALL_NAME"

echo_message "Removing old Neovim installation (if it exists)..."
rm -rf "$INSTALL_DIR"
rm -f "$SYMLINK_PATH"

echo_message "Installing Neovim to $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"
mkdir -p "$BIN_DIR"
mv "$BASE_NAME/"* "$INSTALL_DIR/"

if [ -L "$SYMLINK_PATH" ] && [ "$(readlink -f "$SYMLINK_PATH")" == "$INSTALL_DIR" ]; then
  echo_message "Symbolic link is already up to date. Skipping."
else
  echo_message "Creating/updating symbolic link at $SYMLINK_PATH..."
  rm -f "$SYMLINK_PATH"
  ln -s "$INSTALL_DIR/bin/nvim" "$SYMLINK_PATH"
fi

echo "Neovim has been successfully updated!
Make sure '$BIN_DIR' is in your shell's PATH.
"
$SYMLINK_PATH --version
echo ""
