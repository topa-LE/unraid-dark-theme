#!/bin/bash
set -euo pipefail

# Run the updater from an immutable temporary copy. install.sh replaces the
# persistent update.sh during an update, so continuing to execute directly
# from /boot could make Bash read newly written script contents mid-run.
if [[ "${TOPA_UPDATE_TEMP_COPY:-0}" != "1" ]]; then
  UPDATE_SOURCE="$(readlink -f "${BASH_SOURCE[0]}")"
  UPDATE_TEMP="$(mktemp /tmp/topa-le-update.XXXXXX.sh)"

  cp -f "$UPDATE_SOURCE" "$UPDATE_TEMP"

  TOPA_UPDATE_TEMP_COPY=1 \
  TOPA_UPDATE_SCRIPT_DIR="$(cd "$(dirname "$UPDATE_SOURCE")" && pwd)" \
  exec bash "$UPDATE_TEMP" "$@"
fi

SCRIPT_DIR="${TOPA_UPDATE_SCRIPT_DIR:?Missing original update script directory}"
I18N="$SCRIPT_DIR/lib/i18n.sh"

if [[ ! -f "$I18N" ]]; then
  echo "Error: Language library not found: $I18N" >&2
  exit 1
fi

source "$I18N"

if [[ $EUID -ne 0 ]]; then
  topa_msg error_root_update
  exit 1
fi

REPO_URL="https://github.com/topa-LE/unraid-dark-theme/archive/refs/heads/main.tar.gz"
TMP_DIR="$(mktemp -d /tmp/topa-le-unraid-theme.XXXXXX)"
ARCHIVE="$TMP_DIR/theme.tar.gz"

cleanup() {
  rm -rf "$TMP_DIR"

  if [[ "${TOPA_UPDATE_TEMP_COPY:-0}" == "1" ]]; then
    rm -f "${BASH_SOURCE[0]}"
  fi
}
trap cleanup EXIT

topa_msg update_heading
echo

if ! command -v curl >/dev/null 2>&1; then
  topa_msg error_curl_missing
  exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
  topa_msg error_tar_missing
  exit 1
fi

topa_msg update_download
curl -fsSL "$REPO_URL" -o "$ARCHIVE"

tar -xzf "$ARCHIVE" -C "$TMP_DIR"

SOURCE_DIR="$TMP_DIR/unraid-dark-theme-main"

if [[ ! -f "$SOURCE_DIR/scripts/install.sh" ]]; then
  topa_msg error_install_script_missing
  exit 1
fi

TOPA_LANG="$TOPA_LANG" bash "$SOURCE_DIR/scripts/install.sh"

echo
topa_msg update_finished
