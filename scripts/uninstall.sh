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
STATE_DIR="$TARGET/state"
LOGIN_CASE_ORIGINAL="$STATE_DIR/login-case.original"

MARK_START="# topa-LE Unraid Dark Theme - START"
MARK_END="# topa-LE Unraid Dark Theme - END"

echo "===== topa-LE Deinstallation ====="
echo

# Vor jeder Änderung prüfen, ob ein vorhandener topa-LE Login-Case
# auch zuverlässig auf den ursprünglichen Unraid-Stand zurückgesetzt werden kann.
if [[ -f "$LOGIN" ]] && grep -Fq 'class="topa-login-avatar"' "$LOGIN"; then
  if [[ ! -s "$LOGIN_CASE_ORIGINAL" ]]; then
    echo "Fehler: Originaler Login-Case fehlt: $LOGIN_CASE_ORIGINAL"
    echo "Deinstallation abgebrochen, damit .login.php nicht beschädigt wird."
    exit 1
  fi

  if ! grep -Fq '<div class="case">' "$LOGIN_CASE_ORIGINAL"; then
    echo "Fehler: Gesicherter Login-Case ist ungültig."
    echo "Deinstallation abgebrochen, damit .login.php nicht beschädigt wird."
    exit 1
  fi
fi

if [[ -f "$GO_FILE" ]] && grep -Fqx "$MARK_START" "$GO_FILE"; then
  sed -i "/^${MARK_START//\//\\/}$/,/^${MARK_END//\//\\/}$/d" "$GO_FILE"
  sed -i '${/^$/d;}' "$GO_FILE"
  echo "Boot-Hook entfernt."
fi

if [[ -f "$LAYOUT" ]]; then
  sed -i '/<!-- topa-LE Unraid Dark Theme -->/,+1d' "$LAYOUT"
  sed -i '/<!-- topa-LE Array Operation -->/,+1d' "$LAYOUT"
  echo "WebGUI-Theme-Hooks entfernt."
fi

if [[ -f "$LOGIN" ]]; then
  if grep -Fq 'class="topa-login-avatar"' "$LOGIN"; then
    TMP="/tmp/topa-le-login-restore.$$"

    awk -v original_file="$LOGIN_CASE_ORIGINAL" '
      BEGIN {
        in_case = 0
        is_topa = 0
        buffer = ""
        restored = 0
      }
      {
        if (!in_case && $0 ~ /^[[:space:]]*<div class="case">[[:space:]]*$/) {
          in_case = 1
          is_topa = 0
          buffer = $0 ORS
          next
        }

        if (in_case) {
          buffer = buffer $0 ORS

          if ($0 ~ /class="topa-login-avatar"/) {
            is_topa = 1
          }

          if ($0 ~ /^[[:space:]]*<\/div>[[:space:]]*$/) {
            if (is_topa) {
              while ((getline original_line < original_file) > 0) {
                print original_line
              }
              close(original_file)
              restored = 1
            } else {
              printf "%s", buffer
            }

            in_case = 0
            is_topa = 0
            buffer = ""
          }
          next
        }

        print
      }
      END {
        if (in_case) {
          printf "%s", buffer
        }

        if (!restored) {
          exit 42
        }
      }
    ' "$LOGIN" > "$TMP" || {
      rm -f "$TMP"
      echo "Fehler: Originaler Login-Case konnte nicht wiederhergestellt werden."
      exit 1
    }

    mv "$TMP" "$LOGIN"
    echo "Originaler Login-Case wiederhergestellt."
  fi

  sed -i '/<!-- topa-LE Login Theme -->/,/<\/style>/d' "$LOGIN"
  sed -i '/<div class="topa-login-footer-link">/,/<\/div>/d' "$LOGIN"
  echo "Login-CSS und GitHub-Link entfernt."
fi

# Reste der alten externen Login-Architektur entfernen.
rm -f \
  "/usr/local/emhttp/plugins/dynamix/styles/topa-le-login.css" \
  "/usr/local/emhttp/webGui/images/topa-le-avatar-login.png"

rm -rf "$TARGET"

echo
echo "===== Deinstallation fertig ====="
echo "Browser danach vollständig neu laden."
