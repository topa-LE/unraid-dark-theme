#!/bin/bash
set -euo pipefail

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
I18N="$SOURCE_DIR/scripts/lib/i18n.sh"

if [[ ! -f "$I18N" ]]; then
    echo "Error: Language library not found: $I18N" >&2
    exit 1
fi

source "$I18N"

if [[ $EUID -ne 0 ]]; then
    topa_msg error_root_install
    exit 1
fi

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
    "$SOURCE_DIR/scripts/lib/i18n.sh" \
    "$SOURCE_DIR/scripts/apply.sh" \
    "$SOURCE_DIR/scripts/install.sh" \
    "$SOURCE_DIR/scripts/update.sh" \
    "$SOURCE_DIR/scripts/uninstall.sh"
do
    if [[ ! -f "$FILE" ]]; then
        topa_msg error_source_file_missing "$FILE"
        exit 1
    fi
done

mkdir -p \
    "$TARGET/css" \
    "$TARGET/js" \
    "$TARGET/img" \
    "$TARGET/login" \
    "$TARGET/scripts/lib"

cp -f "$SOURCE_DIR/VERSION" "$TARGET/VERSION"
cp -f "$SOURCE_DIR/css/"*.css "$TARGET/css/"
cp -f "$SOURCE_DIR/js/array-operation.js" "$TARGET/js/"
cp -f "$SOURCE_DIR/js/system-stats.js" "$TARGET/js/"
cp -f "$SOURCE_DIR/img/topa-le-avatar-login.png" "$TARGET/img/"
cp -f "$SOURCE_DIR/login/login-theme.css" "$TARGET/login/"
cp -f "$SOURCE_DIR/scripts/lib/i18n.sh" "$TARGET/scripts/lib/"
cp -f \
    "$SOURCE_DIR/scripts/apply.sh" \
    "$SOURCE_DIR/scripts/install.sh" \
    "$SOURCE_DIR/scripts/update.sh" \
    "$SOURCE_DIR/scripts/uninstall.sh" \
    "$TARGET/scripts/"

# Unraid /boot is typically VFAT; scripts are invoked via bash and do not
# rely on execute bits.

if [[ ! -f "$GO_FILE" ]]; then
    topa_msg error_go_missing
    exit 1
fi

if ! grep -Fq "$MARK_START" "$GO_FILE"; then
    printf '\n%s\n%s\n%s\n' "$MARK_START" "$GO_COMMAND" "$MARK_END" >> "$GO_FILE"
    topa_msg boot_hook_set
else
    topa_msg boot_hook_exists
fi

topa_msg theme_files_installed
echo

TOPA_LANG="$TOPA_LANG" bash "$TARGET/scripts/apply.sh"

echo
topa_msg version "$(cat "$TARGET/VERSION")"
topa_msg installation_finished
