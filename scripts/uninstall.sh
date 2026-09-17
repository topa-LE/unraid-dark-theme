#!/bin/bash
set -euo pipefail

ROOT="/boot/config/custom-css/topa-LE"
I18N="$ROOT/scripts/lib/i18n.sh"

if [[ ! -f "$I18N" ]]; then
  echo "Error: Language library not found: $I18N" >&2
  exit 1
fi

source "$I18N"

if [[ $EUID -ne 0 ]]; then
  topa_msg error_root_uninstall
  exit 1
fi

TARGET="/boot/config/custom-css/topa-LE"
GO_FILE="/boot/config/go"
LAYOUT="/usr/local/emhttp/plugins/dynamix/include/DefaultPageLayout.php"
LOGIN="/usr/local/emhttp/plugins/dynamix/include/.login.php"
BOOT_PAGE="/usr/local/emhttp/plugins/dynamix/include/Boot.php"
STATE_DIR="$TARGET/state"

# Eigenen Theme-Hook der Reboot-/Shutdown-Seite rückstandsfrei entfernen.
if [[ -f "$BOOT_PAGE" ]] && grep -Fq 'topa-LE Reboot Shutdown Theme' "$BOOT_PAGE"; then
  sed -i '/<!-- topa-LE Reboot Shutdown Theme -->/,+1d' "$BOOT_PAGE"
  topa_msg reboot_hook_removed
fi
LOGIN_CASE_ORIGINAL="$STATE_DIR/login-case.original"

TTYD_CONFIG="/etc/default/ttyd"
DYNAMIX_CONFIG="/boot/config/plugins/dynamix/dynamix.cfg"
TTYD_ORIGINAL="$STATE_DIR/ttyd-options.original"
DYNAMIX_TTY_ORIGINAL="$STATE_DIR/dynamix-tty.original"
TTYD_MARKER="# topa-LE WebTerminal Theme"

MARK_START="# topa-LE Unraid Dark Theme - START"
MARK_END="# topa-LE Unraid Dark Theme - END"

topa_msg uninstall_heading
echo

# Vor jeder Änderung prüfen, ob ein vorhandener topa-LE Login-Case
# auch zuverlässig auf den ursprünglichen Unraid-Stand zurückgesetzt werden kann.
if [[ -f "$LOGIN" ]] && grep -Fq 'class="topa-login-avatar"' "$LOGIN"; then
  if [[ ! -s "$LOGIN_CASE_ORIGINAL" ]]; then
    topa_msg error_login_original_missing "$LOGIN_CASE_ORIGINAL"
    topa_msg error_uninstall_login_protection
    exit 1
  fi

  if ! grep -Fq '<div class="case">' "$LOGIN_CASE_ORIGINAL"; then
    topa_msg error_login_original_invalid
    topa_msg error_uninstall_login_protection
    exit 1
  fi
fi

# Ein aktives Terminal-Theme darf nur entfernt werden, wenn der
# ursprüngliche ttyd-Stand zuverlässig gesichert wurde.
if [[ -f "$TTYD_CONFIG" ]] && grep -Fqx "$TTYD_MARKER" "$TTYD_CONFIG"; then
  if [[ ! -s "$TTYD_ORIGINAL" ]]; then
    topa_msg error_ttyd_original_uninstall_missing "$TTYD_ORIGINAL"
    topa_msg error_uninstall_ttyd_protection
    exit 1
  fi
fi

if [[ -f "$GO_FILE" ]] && grep -Fqx "$MARK_START" "$GO_FILE"; then
  sed -i "/^${MARK_START//\//\\/}$/,/^${MARK_END//\//\\/}$/d" "$GO_FILE"
  sed -i '${/^$/d;}' "$GO_FILE"
  topa_msg boot_hook_removed
fi

if [[ -f "$LAYOUT" ]]; then
  sed -i '/<!-- topa-LE Unraid Dark Theme -->/,+1d' "$LAYOUT"
  sed -i '/<!-- topa-LE Array Operation -->/,+1d' "$LAYOUT"
  sed -i '/<!-- topa-LE System Stats -->/,+1d' "$LAYOUT"
  topa_msg webgui_hooks_removed
fi

# WebTerminal auf den vor Installation vorhandenen Unraid-Stand zurücksetzen.
if [[ -f "$TTYD_CONFIG" ]] && grep -Fqx "$TTYD_MARKER" "$TTYD_CONFIG"; then
  ORIGINAL_TTYD_LINE="$(cat "$TTYD_ORIGINAL")"
  TTYD_TMP="/tmp/topa-le-ttyd-restore.$$"
  TTYD_RESTORED=0

  while IFS= read -r LINE || [[ -n "$LINE" ]]; do
    if [[ "$LINE" == "$TTYD_MARKER" ]]; then
      continue
    fi

    if [[ "$LINE" == TTYD_OPTS=* && $TTYD_RESTORED -eq 0 ]]; then
      printf '%s\n' "$ORIGINAL_TTYD_LINE" >> "$TTYD_TMP"
      TTYD_RESTORED=1
    else
      printf '%s\n' "$LINE" >> "$TTYD_TMP"
    fi
  done < "$TTYD_CONFIG"

  if [[ $TTYD_RESTORED -ne 1 ]]; then
    rm -f "$TTYD_TMP"
    topa_msg error_ttyd_restore
    exit 1
  fi

  chmod 0644 "$TTYD_TMP"
  mv "$TTYD_TMP" "$TTYD_CONFIG"
  topa_msg ttyd_restored
fi

# Die ursprüngliche Dynamix-Terminalgröße nur dann zurückschreiben,
# wenn noch unser Theme-Wert 17 aktiv ist. Eine spätere manuelle
# Benutzeränderung wird dadurch nicht überschrieben.
if [[ -s "$DYNAMIX_TTY_ORIGINAL" && -f "$DYNAMIX_CONFIG" ]]; then
  CURRENT_DYNAMIX_TTY="$(grep -m1 '^tty=' "$DYNAMIX_CONFIG" || true)"

  if [[ "$CURRENT_DYNAMIX_TTY" =~ ^tty=\"?17\"?$ ]]; then
    ORIGINAL_DYNAMIX_TTY="$(cat "$DYNAMIX_TTY_ORIGINAL")"
    DYNAMIX_TMP="/tmp/topa-le-dynamix-restore.$$"
    DYNAMIX_RESTORED=0

    while IFS= read -r LINE || [[ -n "$LINE" ]]; do
      if [[ "$LINE" == tty=* && $DYNAMIX_RESTORED -eq 0 ]]; then
        printf '%s\n' "$ORIGINAL_DYNAMIX_TTY" >> "$DYNAMIX_TMP"
        DYNAMIX_RESTORED=1
      else
        printf '%s\n' "$LINE" >> "$DYNAMIX_TMP"
      fi
    done < "$DYNAMIX_CONFIG"

    if [[ $DYNAMIX_RESTORED -ne 1 ]]; then
      rm -f "$DYNAMIX_TMP"
      topa_msg error_dynamix_tty_restore
      exit 1
    fi

    chmod 0644 "$DYNAMIX_TMP"
    mv "$DYNAMIX_TMP" "$DYNAMIX_CONFIG"
    topa_msg dynamix_tty_restored
  else
    topa_msg dynamix_tty_changed
  fi
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
      topa_msg error_login_restore
      exit 1
    }

    mv "$TMP" "$LOGIN"
    topa_msg login_restored
  fi

  sed -i '/<!-- topa-LE Login Theme -->/,/<\/style>/d' "$LOGIN"
  sed -i '/<div class="topa-login-footer-link">/,/<\/div>/d' "$LOGIN"
  topa_msg login_css_github_removed
fi

# Reste der alten externen Login-Architektur entfernen.
rm -f \
  "/usr/local/emhttp/plugins/dynamix/styles/topa-le-login.css" \
  "/usr/local/emhttp/webGui/images/topa-le-avatar-login.png"

rm -rf "$TARGET"

echo
topa_msg uninstall_finished
topa_msg reload_browser
