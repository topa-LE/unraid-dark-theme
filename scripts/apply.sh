#!/bin/bash
set -euo pipefail

ROOT="/boot/config/custom-css/topa-LE"
LAYOUT="/usr/local/emhttp/plugins/dynamix/include/DefaultPageLayout.php"
LOGIN="/usr/local/emhttp/plugins/dynamix/include/.login.php"
STATE_DIR="$ROOT/state"
LOGIN_CASE_ORIGINAL="$STATE_DIR/login-case.original"

TTYD_CONFIG="/etc/default/ttyd"
DYNAMIX_CONFIG="/boot/config/plugins/dynamix/dynamix.cfg"
TTYD_ORIGINAL="$STATE_DIR/ttyd-options.original"
DYNAMIX_TTY_ORIGINAL="$STATE_DIR/dynamix-tty.original"
TTYD_MARKER="# topa-LE WebTerminal Theme"

TTYD_THEME_OPTS="$(cat <<'EOF'
-W -t rendererType=canvas -t closeOnDisconnect=true -t disableLeaveAlert=true -t theme={'background':'#0d1214','foreground':'#c9d1d5','cursor':'#dc9b66','cursorAccent':'#0d1214','selectionBackground':'#2b424e','selectionForeground':'#ffffff','black':'#0d1214','brightBlack':'#65747b','red':'#d86f6f','brightRed':'#ee8585','green':'#81b88b','brightGreen':'#9bc7a4','yellow':'#d5ad72','brightYellow':'#e6c58f','blue':'#739eb5','brightBlue':'#8bb3c7','magenta':'#a98bb8','brightMagenta':'#bea2ca','cyan':'#72adb0','brightCyan':'#8dc2c4','white':'#c9d1d5','brightWhite':'#f0f3f4'} -t fontSize=17 -t fontFamily=Cascadia\20Mono,Consolas,monospace -t fontWeight=300 -t fontWeightBold=500 -t lineHeight=1.15
EOF
)"

CSS_HREF="/boot/config/custom-css/topa-LE/css/loader.css"
JS_HREF="/boot/config/custom-css/topa-LE/js/array-operation.js"
SYSTEM_STATS_JS_HREF="/boot/config/custom-css/topa-LE/js/system-stats.js"

echo "===== topa-LE Runtime ====="

for FILE in \
  "$ROOT/css/loader.css" \
  "$ROOT/js/array-operation.js" \
  "$ROOT/js/system-stats.js" \
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

# WebTerminal über die von Unraid vorgesehene ttyd-Konfiguration gestalten.
mkdir -p "$STATE_DIR"

if [[ ! -f "$TTYD_CONFIG" ]]; then
  echo "Fehler: ttyd-Konfiguration nicht gefunden: $TTYD_CONFIG"
  exit 1
fi

if [[ ! -f "$DYNAMIX_CONFIG" ]]; then
  echo "Fehler: Dynamix-Konfiguration nicht gefunden: $DYNAMIX_CONFIG"
  exit 1
fi

TTYD_CURRENT="$(grep -m1 '^TTYD_OPTS=' "$TTYD_CONFIG" || true)"

if [[ -z "$TTYD_CURRENT" ]]; then
  echo "Fehler: TTYD_OPTS wurde in $TTYD_CONFIG nicht gefunden."
  exit 1
fi

# Originalwert sichern. Nach einem Unraid-Upgrade wird /etc/default/ttyd
# neu erzeugt; wenn unser Marker dann fehlt, wird automatisch der neue
# Unraid-Originalwert als Rückfallstand übernommen.
if ! grep -Fqx "$TTYD_MARKER" "$TTYD_CONFIG"; then
  printf '%s\n' "$TTYD_CURRENT" > "$TTYD_ORIGINAL"
  echo "Originale ttyd-Konfiguration gesichert."
elif [[ ! -s "$TTYD_ORIGINAL" ]]; then
  echo "Fehler: ttyd-Theme ist aktiv, aber die Originalsicherung fehlt."
  exit 1
fi

TTYD_TMP="/tmp/topa-le-ttyd.$$"
TTYD_REPLACED=0

while IFS= read -r LINE || [[ -n "$LINE" ]]; do
  if [[ "$LINE" == "$TTYD_MARKER" ]]; then
    continue
  fi

  if [[ "$LINE" == TTYD_OPTS=* && $TTYD_REPLACED -eq 0 ]]; then
    printf '%s\n' "$TTYD_MARKER" >> "$TTYD_TMP"
    printf 'TTYD_OPTS="%s"\n' "$TTYD_THEME_OPTS" >> "$TTYD_TMP"
    TTYD_REPLACED=1
  else
    printf '%s\n' "$LINE" >> "$TTYD_TMP"
  fi
done < "$TTYD_CONFIG"

if [[ $TTYD_REPLACED -ne 1 ]]; then
  rm -f "$TTYD_TMP"
  echo "Fehler: TTYD_OPTS konnte nicht ersetzt werden."
  exit 1
fi

chmod 0644 "$TTYD_TMP"
mv "$TTYD_TMP" "$TTYD_CONFIG"
echo "WebTerminal-Theme gesetzt."

# Unraid schreibt beim Öffnen eines WebTerminals die in dynamix.cfg
# gespeicherte Schriftgröße erneut nach /etc/default/ttyd.
# Deshalb wird der freigegebene Wert 17 zusätzlich persistent gesetzt.
if [[ ! -s "$DYNAMIX_TTY_ORIGINAL" ]]; then
  if ! grep -m1 '^tty=' "$DYNAMIX_CONFIG" > "$DYNAMIX_TTY_ORIGINAL"; then
    rm -f "$DYNAMIX_TTY_ORIGINAL"
    echo "Fehler: tty-Einstellung wurde in $DYNAMIX_CONFIG nicht gefunden."
    exit 1
  fi
  echo "Originale Dynamix-Terminalgröße gesichert."
fi

if grep -q '^tty=' "$DYNAMIX_CONFIG"; then
  sed -i 's/^tty=.*/tty="17"/' "$DYNAMIX_CONFIG"
  echo "WebTerminal-Schriftgröße persistent auf 17 gesetzt."
else
  echo "Fehler: tty-Einstellung wurde in $DYNAMIX_CONFIG nicht gefunden."
  exit 1
fi


if ! grep -Fq "$CSS_HREF" "$LAYOUT"; then
  sed -i '/<\/head>/i\
<!-- topa-LE Unraid Dark Theme -->\
<link type="text/css" rel="stylesheet" href="/boot/config/custom-css/topa-LE/css/loader.css" />' "$LAYOUT"
  echo "WebGUI-Theme-Hook gesetzt."
else
  echo "WebGUI-Theme-Hook bereits vorhanden."
fi

if ! grep -Fq "$JS_HREF" "$LAYOUT"; then
  sed -i '/<\/head>/i\
<!-- topa-LE Array Operation -->\
<script src="/boot/config/custom-css/topa-LE/js/array-operation.js"></script>' "$LAYOUT"
  echo "Array-Operation-Hook gesetzt."
else
  echo "Array-Operation-Hook bereits vorhanden."
fi

if ! grep -Fq "$SYSTEM_STATS_JS_HREF" "$LAYOUT"; then
  sed -i '/<\/head>/i\
<!-- topa-LE System Stats -->\
<script src="/boot/config/custom-css/topa-LE/js/system-stats.js"></script>' "$LAYOUT"
  echo "System-Stats-Hook gesetzt."
else
  echo "System-Stats-Hook bereits vorhanden."
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
