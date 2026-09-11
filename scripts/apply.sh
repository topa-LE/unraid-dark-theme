#!/bin/bash
set -euo pipefail

ROOT="/boot/config/custom-css/topa-LE"
LAYOUT="/usr/local/emhttp/plugins/dynamix/include/DefaultPageLayout.php"
LOGIN="/usr/local/emhttp/plugins/dynamix/include/.login.php"
STATE_DIR="$ROOT/state"
LOGIN_CASE_ORIGINAL="$STATE_DIR/login-case.original"

CSS_HREF="/boot/config/custom-css/topa-LE/css/loader.css"

echo "===== topa-LE Runtime ====="

for FILE in \
  "$ROOT/css/loader.css" \
  "$ROOT/login/login-theme.css" \
  "$ROOT/img/topa-le-avatar-login.png" \
  "$LAYOUT" \
  "$LOGIN"
do
  if [[ ! -f "$FILE" ]]; then
    echo "Fehler: Datei nicht gefunden: $FILE"
    exit 1
  fi
done


if ! grep -Fq "$CSS_HREF" "$LAYOUT"; then
  sed -i '/<\/head>/i\
<!-- topa-LE Unraid Dark Theme -->\
<link type="text/css" rel="stylesheet" href="/boot/config/custom-css/topa-LE/css/loader.css" />' "$LAYOUT"
  echo "WebGUI-Theme-Hook gesetzt."
else
  echo "WebGUI-Theme-Hook bereits vorhanden."
fi




# Login-Case durch den topa-LE Avatar ersetzen.
if ! grep -Fq 'class="topa-login-avatar"' "$LOGIN"; then
  if ! grep -Fq '<div class="case">' "$LOGIN"; then
    echo "Fehler: Erwartete Login-Case-Struktur nicht gefunden."
    exit 1
  fi

  mkdir -p "$STATE_DIR"

  if [[ ! -f "$LOGIN_CASE_ORIGINAL" ]]; then
    awk '
      BEGIN { capture = 0 }
      {
        if (!capture && $0 ~ /^[[:space:]]*<div class="case">[[:space:]]*$/) {
          capture = 1
        }

        if (capture) {
          print
        }

        if (capture && $0 ~ /^[[:space:]]*<\/div>[[:space:]]*$/) {
          exit
        }
      }
    ' "$LOGIN" > "$LOGIN_CASE_ORIGINAL"

    if [[ ! -s "$LOGIN_CASE_ORIGINAL" ]]; then
      rm -f "$LOGIN_CASE_ORIGINAL"
      echo "Fehler: Originaler Login-Case konnte nicht gesichert werden."
      exit 1
    fi

    echo "Originaler Login-Case gesichert."
  fi

  TMP="/tmp/topa-le-login-case.$$"

  awk '
    BEGIN {
      in_case = 0
      replaced = 0
      dq = sprintf("%c", 34)
      sq = sprintf("%c", 39)
    }
    {
      if (!in_case && $0 ~ /^[[:space:]]*<div class="case">[[:space:]]*$/) {
        print "            <div class=" dq "case" dq ">"
        print "                <img class=" dq "topa-login-avatar" dq " src=" dq "data:image/png;base64,<?= base64_encode(file_get_contents(" sq "/boot/config/custom-css/topa-LE/img/topa-le-avatar-login.png" sq ")) ?>" dq " alt=" dq "topa-LE" dq ">"
        print "            </div>"
        in_case = 1
        replaced = 1
        next
      }

      if (in_case) {
        if ($0 ~ /^[[:space:]]*<\/div>[[:space:]]*$/) {
          in_case = 0
        }
        next
      }

      print
    }
    END {
      if (!replaced) {
        exit 42
      }
    }
  ' "$LOGIN" > "$TMP" || {
    rm -f "$TMP"
    echo "Fehler: Login-Case konnte nicht ersetzt werden."
    exit 1
  }

  mv "$TMP" "$LOGIN"
  echo "Login-Avatar inline eingebettet."
else
  echo "Login-Avatar bereits vorhanden."
fi

# Login-CSS serverseitig einbetten.
if ! grep -Fq 'id="topa-le-login-theme"' "$LOGIN"; then
  TMP="/tmp/topa-le-login-style.$$"

  awk '
    BEGIN {
      dq = sprintf("%c", 34)
      sq = sprintf("%c", 39)
    }
    {
      if (!inserted && $0 ~ /<\/head>/) {
        print "<!-- topa-LE Login Theme -->"
        print "<style id=" dq "topa-le-login-theme" dq ">"
        print "<?php readfile(" sq "/boot/config/custom-css/topa-LE/login/login-theme.css" sq "); ?>"
        print "</style>"
        inserted = 1
      }
      print
    }
    END {
      if (!inserted) {
        exit 42
      }
    }
  ' "$LOGIN" > "$TMP" || {
    rm -f "$TMP"
    echo "Fehler: Login-CSS konnte nicht eingebettet werden."
    exit 1
  }

  mv "$TMP" "$LOGIN"
  echo "Login-CSS serverseitig eingebettet."
else
  echo "Login-CSS bereits vorhanden."
fi

# GitHub-Link im Login-Footer setzen.
if ! grep -Fq 'class="topa-login-footer-link"' "$LOGIN"; then
  if ! grep -Fq 'lost-root-password' "$LOGIN"; then
    echo "Fehler: Passwort-Wiederherstellungsbereich nicht gefunden."
    exit 1
  fi

  TMP="/tmp/topa-le-login-footer.$$"

  awk '
    BEGIN {
      dq = sprintf("%c", 34)
    }
    {
      print
      if (!inserted && $0 ~ /lost-root-password/) {
        print "            <div class=" dq "topa-login-footer-link" dq ">"
        print "                <a class=" dq "topa-login-github-link" dq " href=" dq "https://github.com/topa-LE/unraid-dark-theme" dq " target=" dq "_blank" dq " rel=" dq "noopener noreferrer" dq ">↗ GitHub-Repository Unraid Theme</a>"
        print "            </div>"
        inserted = 1
      }
    }
    END {
      if (!inserted) {
        exit 42
      }
    }
  ' "$LOGIN" > "$TMP" || {
    rm -f "$TMP"
    echo "Fehler: GitHub-Link konnte nicht gesetzt werden."
    exit 1
  }

  mv "$TMP" "$LOGIN"
  echo "GitHub-Link gesetzt."
else
  echo "GitHub-Link bereits vorhanden."
fi

echo "===== Fertig ====="
