#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Fehler: Update muss als root ausgeführt werden."
  exit 1
fi

REPO_URL="https://github.com/topa-LE/unraid-dark-theme/archive/refs/heads/main.tar.gz"
TMP_DIR="$(mktemp -d /tmp/topa-le-unraid-theme.XXXXXX)"
ARCHIVE="$TMP_DIR/theme.tar.gz"

cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "===== topa-LE Theme Update ====="
echo

if ! command -v curl >/dev/null 2>&1; then
  echo "Fehler: curl wurde nicht gefunden."
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  echo "Fehler: tar wurde nicht gefunden."
  exit 1
fi

echo "Aktuelle Version wird von GitHub geladen ..."
curl -fsSL "$REPO_URL" -o "$ARCHIVE"

tar -xzf "$ARCHIVE" -C "$TMP_DIR"

SOURCE_DIR="$TMP_DIR/unraid-dark-theme-main"

if [[ ! -f "$SOURCE_DIR/scripts/install.sh" ]]; then
  echo "Fehler: install.sh im heruntergeladenen Repository nicht gefunden."
  exit 1
fi

bash "$SOURCE_DIR/scripts/install.sh"

echo
echo "===== Update fertig ====="
