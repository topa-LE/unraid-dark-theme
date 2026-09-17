#!/bin/bash
set -euo pipefail

# ==========================================================
# topa-LE Unraid Dark Theme - Fresh Install Bootstrap
#
# TOPA_LANG=de  -> German
# TOPA_LANG=en  -> English
#
# Without explicit selection:
#   German locale -> German
#   all others    -> English
# ==========================================================

detect_bootstrap_language() {
    if [[ -n "${TOPA_LANG:-}" ]]; then
        case "${TOPA_LANG,,}" in
            de|de_*)
                TOPA_LANG="de"
                ;;
            en|en_*)
                TOPA_LANG="en"
                ;;
            *)
                TOPA_LANG="en"
                ;;
        esac
    else
        local locale="${LC_ALL:-${LC_MESSAGES:-${LANG:-}}}"
        locale="${locale,,}"

        case "$locale" in
            de|de_*|de.*)
                TOPA_LANG="de"
                ;;
            *)
                TOPA_LANG="en"
                ;;
        esac
    fi

    export TOPA_LANG
}

bootstrap_msg() {
    local key="$1"

    case "$TOPA_LANG:$key" in
        de:error_root)
            printf 'Fehler: Installation muss als root ausgeführt werden.\n'
            ;;
        en:error_root)
            printf 'Error: Installation must be run as root.\n'
            ;;

        de:fresh_install)
            printf 'Neuinstallation\n'
            ;;
        en:fresh_install)
            printf 'Fresh Installation\n'
            ;;

        de:error_curl)
            printf 'Fehler: curl wurde nicht gefunden.\n'
            ;;
        en:error_curl)
            printf 'Error: curl was not found.\n'
            ;;

        de:error_tar)
            printf 'Fehler: tar wurde nicht gefunden.\n'
            ;;
        en:error_tar)
            printf 'Error: tar was not found.\n'
            ;;

        de:download)
            printf 'Aktuelles Repository wird von GitHub geladen ...\n'
            ;;
        en:download)
            printf 'Downloading the current repository from GitHub ...\n'
            ;;

        de:downloaded)
            printf 'Repository erfolgreich geladen.\n'
            ;;
        en:downloaded)
            printf 'Repository downloaded successfully.\n'
            ;;

        de:error_install_missing)
            printf 'Fehler: install.sh im heruntergeladenen Repository nicht gefunden.\n'
            ;;
        en:error_install_missing)
            printf 'Error: install.sh was not found in the downloaded repository.\n'
            ;;

        de:starting)
            printf 'Installation wird gestartet ...\n'
            ;;
        en:starting)
            printf 'Starting installation ...\n'
            ;;

        de:finished)
            printf '===== Neuinstallation fertig =====\n'
            ;;
        en:finished)
            printf '===== Fresh Installation complete =====\n'
            ;;
    esac
}

detect_bootstrap_language

if [[ $EUID -ne 0 ]]; then
    bootstrap_msg error_root
    exit 1
fi

REPO_URL="https://github.com/topa-LE/unraid-dark-theme/archive/refs/heads/main.tar.gz"
TMP_DIR="$(mktemp -d /tmp/topa-le-unraid-theme-bootstrap.XXXXXX)"
ARCHIVE="$TMP_DIR/theme.tar.gz"

cleanup() {
    rm -rf "$TMP_DIR"
}
trap cleanup EXIT

echo "===== topa-LE Unraid Dark Theme ====="
echo
bootstrap_msg fresh_install
echo

if ! command -v curl >/dev/null 2>&1; then
    bootstrap_msg error_curl
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    bootstrap_msg error_tar
    exit 1
fi

bootstrap_msg download

curl -fsSL "$REPO_URL" -o "$ARCHIVE"

bootstrap_msg downloaded

tar -xzf "$ARCHIVE" -C "$TMP_DIR"

SOURCE_DIR="$TMP_DIR/unraid-dark-theme-main"

if [[ ! -f "$SOURCE_DIR/scripts/install.sh" ]]; then
    bootstrap_msg error_install_missing
    exit 1
fi

echo
bootstrap_msg starting
echo

TOPA_LANG="$TOPA_LANG" bash "$SOURCE_DIR/scripts/install.sh"

echo
bootstrap_msg finished
