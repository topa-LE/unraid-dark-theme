#!/bin/bash
set -euo pipefail

ROOT="/boot/config/custom-css/topa-LE"
LAYOUT="/usr/local/emhttp/plugins/dynamix/include/DefaultPageLayout.php"
LOGIN="/usr/local/emhttp/plugins/dynamix/include/.login.php"
RUNTIME_LOGIN_CSS="/usr/local/emhttp/plugins/dynamix/styles/topa-le-login.css"
RUNTIME_AVATAR="/usr/local/emhttp/webGui/images/topa-le-avatar-login.png"

CSS_HREF="/boot/config/custom-css/topa-LE/css/loader.css"
LOGIN_CSS_HREF="/plugins/dynamix/styles/topa-le-login.css"

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

cp -f "$ROOT/login/login-theme.css" "$RUNTIME_LOGIN_CSS"
cp -f "$ROOT/img/topa-le-avatar-login.png" "$RUNTIME_AVATAR"

if ! grep -Fq "$CSS_HREF" "$LAYOUT"; then
  sed -i '/<\/head>/i\
<!-- topa-LE Unraid Dark Theme -->\
<link type="text/css" rel="stylesheet" href="/boot/config/custom-css/topa-LE/css/loader.css" />' "$LAYOUT"
  echo "WebGUI-Theme-Hook gesetzt."
else
  echo "WebGUI-Theme-Hook bereits vorhanden."
fi

if ! grep -Fq "$LOGIN_CSS_HREF" "$LOGIN"; then
  sed -i '/<\/head>/i\
<!-- topa-LE Login Theme -->\
<link type="text/css" rel="stylesheet" href="/plugins/dynamix/styles/topa-le-login.css" />' "$LOGIN"
  echo "Login-CSS-Hook gesetzt."
else
  echo "Login-CSS-Hook bereits vorhanden."
fi

if ! grep -Fq 'class="topa-login-avatar"' "$LOGIN"; then
  sed -i '/<div class="case">/a\
                <img class="topa-login-avatar" src="/webGui/images/topa-le-avatar-login.png" alt="topa-LE">' "$LOGIN"
  echo "Login-Avatar gesetzt."
else
  echo "Login-Avatar bereits vorhanden."
fi

if ! grep -Fq 'class="topa-login-footer-link"' "$LOGIN"; then
  sed -i '/lost-root-password/a\
            <div class="topa-login-footer-link">\
                <a class="topa-login-github-link" href="https://github.com/topa-LE/unraid-dark-theme" target="_blank" rel="noopener noreferrer">GitHub Repository - Unraid Theme</a>\
            </div>' "$LOGIN"
  echo "GitHub-Link gesetzt."
else
  echo "GitHub-Link bereits vorhanden."
fi

echo "===== Fertig ====="
