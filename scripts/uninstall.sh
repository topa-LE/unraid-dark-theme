#!/bin/bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "Fehler: Deinstallation muss als root ausgeführt werden."
  exit 1
fi

TARGET="/boot/config/custom-css/topa-LE"
GO_FILE="/boot/config/go"
LAYOUT="/usr/local/emhttp/plugins/dynamix/include/DefaultPageLayout.php"
LOGIN="/usr/local/emhttp/plugins/dynamix/include/.login.php"
RUNTIME_LOGIN_CSS="/usr/local/emhttp/plugins/dynamix/styles/topa-le-login.css"
RUNTIME_AVATAR="/usr/local/emhttp/webGui/images/topa-le-avatar-login.png"

MARK_START="# topa-LE Unraid Dark Theme - START"
MARK_END="# topa-LE Unraid Dark Theme - END"

echo "===== topa-LE Deinstallation ====="
echo

if [[ -f "$GO_FILE" ]]; then
  sed -i "/^${MARK_START//\//\\/}$/,/^${MARK_END//\//\\/}$/d" "$GO_FILE"
  echo "Boot-Hook entfernt."
fi

if [[ -f "$LAYOUT" ]]; then
  sed -i '/<!-- topa-LE Unraid Dark Theme -->/,+1d' "$LAYOUT"
  echo "WebGUI-Theme-Hook entfernt."
fi

if [[ -f "$LOGIN" ]]; then
  sed -i '/<!-- topa-LE Login Theme -->/,+1d' "$LOGIN"
  sed -i '/class="topa-login-avatar"/d' "$LOGIN"
  sed -i '/<div class="topa-login-footer-link">/,+2d' "$LOGIN"
  echo "Login-Anpassungen entfernt."
fi

rm -f "$RUNTIME_LOGIN_CSS" "$RUNTIME_AVATAR"
rm -rf "$TARGET"

echo
echo "===== Deinstallation fertig ====="
echo "Browser danach vollständig neu laden."
