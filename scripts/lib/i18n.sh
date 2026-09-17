#!/bin/bash

# ==========================================================
# topa-LE Unraid Dark Theme - Internationalization
#
# Supported languages:
#   de = German
#   en = English
#
# Manual selection:
#   TOPA_LANG=de
#   TOPA_LANG=en
#
# Without manual selection, the system locale is evaluated.
# English is used as the fallback for all unsupported languages.
# ==========================================================

topa_detect_language() {
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

        export TOPA_LANG
        return
    fi

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

    export TOPA_LANG
}


topa_msg() {
    local key="$1"
    shift || true

    case "${TOPA_LANG:-en}:$key" in

        # --------------------------------------------------
        # General
        # --------------------------------------------------

        de:error_root_install)
            printf 'Fehler: Installation muss als root ausgeführt werden.\n'
            ;;
        en:error_root_install)
            printf 'Error: Installation must be run as root.\n'
            ;;

        de:error_root_update)
            printf 'Fehler: Update muss als root ausgeführt werden.\n'
            ;;
        en:error_root_update)
            printf 'Error: Update must be run as root.\n'
            ;;

        de:error_root_uninstall)
            printf 'Fehler: Deinstallation muss als root ausgeführt werden.\n'
            ;;
        en:error_root_uninstall)
            printf 'Error: Uninstallation must be run as root.\n'
            ;;

        de:error_curl_missing)
            printf 'Fehler: curl wurde nicht gefunden.\n'
            ;;
        en:error_curl_missing)
            printf 'Error: curl was not found.\n'
            ;;

        de:error_tar_missing)
            printf 'Fehler: tar wurde nicht gefunden.\n'
            ;;
        en:error_tar_missing)
            printf 'Error: tar was not found.\n'
            ;;

        de:error_file_missing)
            printf 'Fehler: Datei nicht gefunden: %s\n' "$1"
            ;;
        en:error_file_missing)
            printf 'Error: File not found: %s\n' "$1"
            ;;

        de:error_source_file_missing)
            printf 'Fehler: Quelldatei fehlt: %s\n' "$1"
            ;;
        en:error_source_file_missing)
            printf 'Error: Source file is missing: %s\n' "$1"
            ;;

        de:error_install_script_missing)
            printf 'Fehler: install.sh im heruntergeladenen Repository nicht gefunden.\n'
            ;;
        en:error_install_script_missing)
            printf 'Error: install.sh was not found in the downloaded repository.\n'
            ;;

        # --------------------------------------------------
        # Bootstrap / Download
        # --------------------------------------------------

        de:fresh_install)
            printf 'Neuinstallation\n'
            ;;
        en:fresh_install)
            printf 'Fresh Installation\n'
            ;;

        de:download_repository)
            printf 'Aktuelles Repository wird von GitHub geladen ...\n'
            ;;
        en:download_repository)
            printf 'Downloading the current repository from GitHub ...\n'
            ;;

        de:repository_downloaded)
            printf 'Repository erfolgreich geladen.\n'
            ;;
        en:repository_downloaded)
            printf 'Repository downloaded successfully.\n'
            ;;

        de:installation_starting)
            printf 'Installation wird gestartet ...\n'
            ;;
        en:installation_starting)
            printf 'Starting installation ...\n'
            ;;

        de:fresh_install_finished)
            printf '===== Neuinstallation fertig =====\n'
            ;;
        en:fresh_install_finished)
            printf '===== Fresh Installation complete =====\n'
            ;;

        # --------------------------------------------------
        # Installation
        # --------------------------------------------------

        de:error_go_missing)
            printf 'Fehler: /boot/config/go nicht gefunden.\n'
            ;;
        en:error_go_missing)
            printf 'Error: /boot/config/go was not found.\n'
            ;;

        de:boot_hook_set)
            printf 'Boot-Hook gesetzt.\n'
            ;;
        en:boot_hook_set)
            printf 'Boot hook installed.\n'
            ;;

        de:boot_hook_exists)
            printf 'Boot-Hook bereits vorhanden.\n'
            ;;
        en:boot_hook_exists)
            printf 'Boot hook already installed.\n'
            ;;

        de:theme_files_installed)
            printf 'Theme-Dateien persistent installiert.\n'
            ;;
        en:theme_files_installed)
            printf 'Theme files installed persistently.\n'
            ;;

        de:version)
            printf 'Version: %s\n' "$1"
            ;;
        en:version)
            printf 'Version: %s\n' "$1"
            ;;

        de:installation_finished)
            printf '===== Installation fertig =====\n'
            ;;
        en:installation_finished)
            printf '===== Installation complete =====\n'
            ;;

        # --------------------------------------------------
        # Runtime / Apply
        # --------------------------------------------------

        de:error_ttyd_config_missing)
            printf 'Fehler: ttyd-Konfiguration nicht gefunden: %s\n' "$1"
            ;;
        en:error_ttyd_config_missing)
            printf 'Error: ttyd configuration not found: %s\n' "$1"
            ;;

        de:error_dynamix_config_missing)
            printf 'Fehler: Dynamix-Konfiguration nicht gefunden: %s\n' "$1"
            ;;
        en:error_dynamix_config_missing)
            printf 'Error: Dynamix configuration not found: %s\n' "$1"
            ;;

        de:error_ttyd_opts_missing)
            printf 'Fehler: TTYD_OPTS wurde in %s nicht gefunden.\n' "$1"
            ;;
        en:error_ttyd_opts_missing)
            printf 'Error: TTYD_OPTS was not found in %s.\n' "$1"
            ;;

        de:ttyd_original_saved)
            printf 'Originale ttyd-Konfiguration gesichert.\n'
            ;;
        en:ttyd_original_saved)
            printf 'Original ttyd configuration saved.\n'
            ;;

        de:error_ttyd_original_missing)
            printf 'Fehler: ttyd-Theme ist aktiv, aber die Originalsicherung fehlt.\n'
            ;;
        en:error_ttyd_original_missing)
            printf 'Error: ttyd theme is active, but the original backup is missing.\n'
            ;;

        de:error_ttyd_replace)
            printf 'Fehler: TTYD_OPTS konnte nicht ersetzt werden.\n'
            ;;
        en:error_ttyd_replace)
            printf 'Error: TTYD_OPTS could not be replaced.\n'
            ;;

        de:webterminal_theme_set)
            printf 'WebTerminal-Theme gesetzt.\n'
            ;;
        en:webterminal_theme_set)
            printf 'WebTerminal theme applied.\n'
            ;;

        de:error_dynamix_tty_missing)
            printf 'Fehler: tty-Einstellung wurde in %s nicht gefunden.\n' "$1"
            ;;
        en:error_dynamix_tty_missing)
            printf 'Error: tty setting was not found in %s.\n' "$1"
            ;;

        de:dynamix_tty_original_saved)
            printf 'Originale Dynamix-Terminalgröße gesichert.\n'
            ;;
        en:dynamix_tty_original_saved)
            printf 'Original Dynamix terminal size saved.\n'
            ;;

        de:webterminal_font_size_set)
            printf 'WebTerminal-Schriftgröße persistent auf 17 gesetzt.\n'
            ;;
        en:webterminal_font_size_set)
            printf 'WebTerminal font size persistently set to 17.\n'
            ;;

        de:boot_page_hook_set)
            printf 'Reboot-/Shutdown-Theme-Hook gesetzt.\n'
            ;;
        en:boot_page_hook_set)
            printf 'Reboot/shutdown theme hook installed.\n'
            ;;

        de:boot_page_hook_exists)
            printf 'Reboot-/Shutdown-Theme-Hook bereits vorhanden.\n'
            ;;
        en:boot_page_hook_exists)
            printf 'Reboot/shutdown theme hook already installed.\n'
            ;;

        de:warning_boot_page_missing)
            printf 'Warnung: Boot.php wurde nicht gefunden: %s\n' "$1"
            ;;
        en:warning_boot_page_missing)
            printf 'Warning: Boot.php was not found: %s\n' "$1"
            ;;

        de:webgui_hook_set)
            printf 'WebGUI-Theme-Hook gesetzt.\n'
            ;;
        en:webgui_hook_set)
            printf 'WebGUI theme hook installed.\n'
            ;;

        de:webgui_hook_exists)
            printf 'WebGUI-Theme-Hook bereits vorhanden.\n'
            ;;
        en:webgui_hook_exists)
            printf 'WebGUI theme hook already installed.\n'
            ;;

        de:array_hook_set)
            printf 'Array-Operation-Hook gesetzt.\n'
            ;;
        en:array_hook_set)
            printf 'Array operation hook installed.\n'
            ;;

        de:array_hook_exists)
            printf 'Array-Operation-Hook bereits vorhanden.\n'
            ;;
        en:array_hook_exists)
            printf 'Array operation hook already installed.\n'
            ;;

        de:stats_hook_set)
            printf 'System-Stats-Hook gesetzt.\n'
            ;;
        en:stats_hook_set)
            printf 'System stats hook installed.\n'
            ;;

        de:stats_hook_exists)
            printf 'System-Stats-Hook bereits vorhanden.\n'
            ;;
        en:stats_hook_exists)
            printf 'System stats hook already installed.\n'
            ;;

        de:error_login_case_structure)
            printf 'Fehler: Erwartete Login-Case-Struktur nicht gefunden.\n'
            ;;
        en:error_login_case_structure)
            printf 'Error: Expected login case structure was not found.\n'
            ;;

        de:error_login_case_save)
            printf 'Fehler: Originaler Login-Case konnte nicht gesichert werden.\n'
            ;;
        en:error_login_case_save)
            printf 'Error: Original login case could not be saved.\n'
            ;;

        de:login_case_saved)
            printf 'Originaler Login-Case gesichert.\n'
            ;;
        en:login_case_saved)
            printf 'Original login case saved.\n'
            ;;

        de:error_login_case_replace)
            printf 'Fehler: Login-Case konnte nicht ersetzt werden.\n'
            ;;
        en:error_login_case_replace)
            printf 'Error: Login case could not be replaced.\n'
            ;;

        de:login_avatar_embedded)
            printf 'Login-Avatar inline eingebettet.\n'
            ;;
        en:login_avatar_embedded)
            printf 'Login avatar embedded inline.\n'
            ;;

        de:login_avatar_exists)
            printf 'Login-Avatar bereits vorhanden.\n'
            ;;
        en:login_avatar_exists)
            printf 'Login avatar already present.\n'
            ;;

        de:error_login_css_embed)
            printf 'Fehler: Login-CSS konnte nicht eingebettet werden.\n'
            ;;
        en:error_login_css_embed)
            printf 'Error: Login CSS could not be embedded.\n'
            ;;

        de:login_css_embedded)
            printf 'Login-CSS serverseitig eingebettet.\n'
            ;;
        en:login_css_embedded)
            printf 'Login CSS embedded server-side.\n'
            ;;

        de:login_css_exists)
            printf 'Login-CSS bereits vorhanden.\n'
            ;;
        en:login_css_exists)
            printf 'Login CSS already present.\n'
            ;;

        de:error_password_recovery_area)
            printf 'Fehler: Passwort-Wiederherstellungsbereich nicht gefunden.\n'
            ;;
        en:error_password_recovery_area)
            printf 'Error: Password recovery section was not found.\n'
            ;;

        de:error_github_link_set)
            printf 'Fehler: GitHub-Link konnte nicht gesetzt werden.\n'
            ;;
        en:error_github_link_set)
            printf 'Error: GitHub link could not be added.\n'
            ;;

        de:github_link_set)
            printf 'GitHub-Link gesetzt.\n'
            ;;
        en:github_link_set)
            printf 'GitHub link added.\n'
            ;;

        de:github_link_exists)
            printf 'GitHub-Link bereits vorhanden.\n'
            ;;
        en:github_link_exists)
            printf 'GitHub link already present.\n'
            ;;

        de:runtime_finished)
            printf '===== Fertig =====\n'
            ;;
        en:runtime_finished)
            printf '===== Complete =====\n'
            ;;

        # --------------------------------------------------
        # Script headings
        # --------------------------------------------------

        de:update_heading)
            printf '===== topa-LE Theme Update =====\n'
            ;;
        en:update_heading)
            printf '===== topa-LE Theme Update =====\n'
            ;;

        de:uninstall_heading)
            printf '===== topa-LE Deinstallation =====\n'
            ;;
        en:uninstall_heading)
            printf '===== topa-LE Uninstallation =====\n'
            ;;

        # --------------------------------------------------
        # Update
        # --------------------------------------------------

        de:update_download)
            printf 'Aktuelle Version wird von GitHub geladen ...\n'
            ;;
        en:update_download)
            printf 'Downloading the current version from GitHub ...\n'
            ;;

        de:update_finished)
            printf '===== Update fertig =====\n'
            ;;
        en:update_finished)
            printf '===== Update complete =====\n'
            ;;

        # --------------------------------------------------
        # Uninstall
        # --------------------------------------------------

        de:reboot_hook_removed)
            printf 'Reboot-/Shutdown-Theme-Hook entfernt.\n'
            ;;
        en:reboot_hook_removed)
            printf 'Reboot/shutdown theme hook removed.\n'
            ;;

        de:error_login_original_missing)
            printf 'Fehler: Originaler Login-Case fehlt: %s\n' "$1"
            ;;
        en:error_login_original_missing)
            printf 'Error: Original login case is missing: %s\n' "$1"
            ;;

        de:error_uninstall_login_protection)
            printf 'Deinstallation abgebrochen, damit .login.php nicht beschädigt wird.\n'
            ;;
        en:error_uninstall_login_protection)
            printf 'Uninstallation aborted to prevent damage to .login.php.\n'
            ;;

        de:error_login_original_invalid)
            printf 'Fehler: Gesicherter Login-Case ist ungültig.\n'
            ;;
        en:error_login_original_invalid)
            printf 'Error: Saved original login case is invalid.\n'
            ;;

        de:error_ttyd_original_uninstall_missing)
            printf 'Fehler: Originale ttyd-Konfiguration fehlt: %s\n' "$1"
            ;;
        en:error_ttyd_original_uninstall_missing)
            printf 'Error: Original ttyd configuration is missing: %s\n' "$1"
            ;;

        de:error_uninstall_ttyd_protection)
            printf 'Deinstallation abgebrochen, damit ttyd nicht beschädigt wird.\n'
            ;;
        en:error_uninstall_ttyd_protection)
            printf 'Uninstallation aborted to prevent damage to ttyd.\n'
            ;;

        de:boot_hook_removed)
            printf 'Boot-Hook entfernt.\n'
            ;;
        en:boot_hook_removed)
            printf 'Boot hook removed.\n'
            ;;

        de:webgui_hooks_removed)
            printf 'WebGUI-Theme-Hooks entfernt.\n'
            ;;
        en:webgui_hooks_removed)
            printf 'WebGUI theme hooks removed.\n'
            ;;

        de:error_ttyd_restore)
            printf 'Fehler: Originale ttyd-Konfiguration konnte nicht wiederhergestellt werden.\n'
            ;;
        en:error_ttyd_restore)
            printf 'Error: Original ttyd configuration could not be restored.\n'
            ;;

        de:ttyd_restored)
            printf 'Originale ttyd-Konfiguration wiederhergestellt.\n'
            ;;
        en:ttyd_restored)
            printf 'Original ttyd configuration restored.\n'
            ;;

        de:error_dynamix_tty_restore)
            printf 'Fehler: Dynamix-Terminalgröße konnte nicht wiederhergestellt werden.\n'
            ;;
        en:error_dynamix_tty_restore)
            printf 'Error: Dynamix terminal size could not be restored.\n'
            ;;

        de:dynamix_tty_restored)
            printf 'Originale Dynamix-Terminalgröße wiederhergestellt.\n'
            ;;
        en:dynamix_tty_restored)
            printf 'Original Dynamix terminal size restored.\n'
            ;;

        de:dynamix_tty_changed)
            printf 'Dynamix-Terminalgröße wurde zwischenzeitlich geändert und bleibt unangetastet.\n'
            ;;
        en:dynamix_tty_changed)
            printf 'Dynamix terminal size was changed after installation and will be left untouched.\n'
            ;;

        de:error_login_restore)
            printf 'Fehler: Originaler Login-Case konnte nicht wiederhergestellt werden.\n'
            ;;
        en:error_login_restore)
            printf 'Error: Original login case could not be restored.\n'
            ;;

        de:login_restored)
            printf 'Originaler Login-Case wiederhergestellt.\n'
            ;;
        en:login_restored)
            printf 'Original login case restored.\n'
            ;;

        de:login_css_github_removed)
            printf 'Login-CSS und GitHub-Link entfernt.\n'
            ;;
        en:login_css_github_removed)
            printf 'Login CSS and GitHub link removed.\n'
            ;;

        de:uninstall_finished)
            printf '===== Deinstallation fertig =====\n'
            ;;
        en:uninstall_finished)
            printf '===== Uninstallation complete =====\n'
            ;;

        de:reload_browser)
            printf 'Browser danach vollständig neu laden.\n'
            ;;
        en:reload_browser)
            printf 'Reload the browser completely afterwards.\n'
            ;;

        # --------------------------------------------------
        # Fallback
        # --------------------------------------------------

        *)
            printf 'Unknown message key: %s\n' "$key" >&2
            return 1
            ;;
    esac
}


topa_detect_language
