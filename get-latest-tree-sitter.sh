#!/usr/bin/env bash
set -e

REPO="tree-sitter/tree-sitter"
INSTALL_DIR="/usr/local/bin"

# Detectar OS y arquitectura
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "$ARCH" in
  x86_64) ARCH="x64" ;;
  aarch64) ARCH="arm64" ;;
  armv7l)  ARCH="arm" ;;
  i386|i686) ARCH="x86" ;;
  *) echo "Arquitectura no soportada: $ARCH" >&2; exit 1 ;;
esac

ASSET_NAME="tree-sitter-cli-${OS}-${ARCH}.zip"

# Consultar API de GitHub
RELEASE_JSON=$(curl -fsSL "https://api.github.com/repos/$REPO/releases/latest")
VERSION=$(echo "$RELEASE_JSON" | jq -r '.tag_name')
ASSET_URL=$(echo "$RELEASE_JSON" | jq -r ".assets[] | select(.name == \"$ASSET_NAME\") | .browser_download_url")
EXPECTED_SHA=$(echo "$RELEASE_JSON" | jq -r ".assets[] | select(.name == \"$ASSET_NAME\") | .digest" | cut -d: -f2)

if [ -z "$ASSET_URL" ] || [ "$ASSET_URL" = "null" ]; then
  echo "No se encontró el asset $ASSET_NAME para $VERSION" >&2
  exit 1
fi

TMP_DIR=$(mktemp -d)
trap 'rm -rf "$TMP_DIR"' EXIT
cd "$TMP_DIR"

echo "Descargando tree-sitter $VERSION ($ASSET_NAME)..."
curl -fLO "$ASSET_URL"

echo "Verificando checksum SHA256..."
echo "$EXPECTED_SHA  $ASSET_NAME" | sha256sum -c -

echo "Extrayendo..."
unzip -q "$ASSET_NAME"

echo "Instalando en $INSTALL_DIR (requiere sudo)..."
sudo install -m 755 tree-sitter "$INSTALL_DIR/"

echo ""
echo "tree-sitter $VERSION instalado correctamente"
tree-sitter --version
