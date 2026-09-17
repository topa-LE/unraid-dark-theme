#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Fehler: Installation muss als root ausgefuehrt werden."
  exit 1
fi

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET="/boot/config/custom-css/topa-LE"
GO_FILE="/boot/config/go"

MARK_START="# topa-LE Unraid Dark Theme - START"
MARK_END="# topa-LE Unraid Dark Theme - END"
GO_COMMAND="bash /boot/config/custom-css/topa-LE/scripts/apply.sh"

echo "===== topa-LE Installation ====="
echo

for FILE in \
  "$SOURCE_DIR/VERSION" \
  "$SOURCE_DIR/css/base.css" \
  "$SOURCE_DIR/css/boot.css" \
  "$SOURCE_DIR/css/loader.css" \
  "$SOURCE_DIR/css/theme.css" \
  "$SOURCE_DIR/css/overrides.css" \
  "$SOURCE_DIR/js/array-operation.js" \
  "$SOURCE_DIR/js/system-stats.js" \
  "$SOURCE_DIR/img/topa-le-avatar-login.png" \
  "$SOURCE_DIR/login/login-theme.css" \
  "$SOURCE_DIR/scripts/apply.sh" \
  "$SOURCE_DIR/scripts/install.sh" \
  "$SOURCE_DIR/scripts/update.sh" \
  "$SOURCE_DIR/scripts/uninstall.sh"
do
  if [[ ! -f "$FILE" ]]; then
    echo "Fehler: Quelldatei fehlt: $FILE"
    exit 1
  fi
done

mkdir -p "$TARGET/css" "$TARGET/js" "$TARGET/img" "$TARGET/login" "$TARGET/scripts"

cp -f "$SOURCE_DIR/VERSION" "$TARGET/VERSION"
cp -f "$SOURCE_DIR/css/"*.css "$TARGET/css/"
cp -f "$SOURCE_DIR/js/array-operation.js" "$TARGET/js/"
cp -f "$SOURCE_DIR/js/system-stats.js" "$TARGET/js/"
cp -f "$SOURCE_DIR/img/topa-le-avatar-login.png" "$TARGET/img/"
cp -f "$SOURCE_DIR/login/login-theme.css" "$TARGET/login/"
cp -f "$SOURCE_DIR/scripts/apply.sh" \
  "$SOURCE_DIR/scripts/install.sh" \
  "$SOURCE_DIR/scripts/update.sh" \
  "$SOURCE_DIR/scripts/uninstall.sh" "$TARGET/scripts/"
# Unraid /boot is typically VFAT; scripts are invoked via bash and do not rely on execute bits.

if [[ ! -f "$GO_FILE" ]]; then
  echo "Fehler: /boot/config/go nicht gefunden."
  exit 1
fi

if ! grep -Fq "$MARK_START" "$GO_FILE"; then
  printf '\n%s\n%s\n%s\n' "$MARK_START" "$GO_COMMAND" "$MARK_END" >> "$GO_FILE"
  echo "Boot-Hook gesetzt."
else
  echo "Boot-Hook bereits vorhanden."
fi

echo "Theme-Dateien persistent installiert."
echo

bash "$TARGET/scripts/apply.sh"

echo
echo "Version: $(cat "$TARGET/VERSION")"
echo "===== Installation fertig ====="
