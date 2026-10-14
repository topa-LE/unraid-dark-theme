/*
 * topa-LE Unraid Dark Theme
 * Language Switch Fix
 *
 * Preserve the last selected non-default language.
 * Keep Unraid's original language switching mechanism intact.
 */
(function topaLanguageSwitchFix() {
    "use strict";

    const STORAGE_KEY = "topa-last-language";

    function validLocale(value) {
        return typeof value === "string" &&
            /^[a-z]{2,3}_[A-Za-z0-9]+(?:_[A-Za-z0-9]+)*$/.test(value);
    }

    function remember(value) {
        if (!validLocale(value)) return;
        try {
            localStorage.setItem(STORAGE_KEY, value);
        } catch (error) {}
    }

    function recalled() {
        try {
            const value = localStorage.getItem(STORAGE_KEY);
            return validLocale(value) ? value : null;
        } catch (error) {
            return null;
        }
    }

    function install() {
        if (!window.jQuery || !jQuery.cookie ||
            typeof window.switchLanguage !== "function") {
            return false;
        }

        const original = window.switchLanguage;
        if (original.topaLanguageFix) return true;

        function wrappedSwitchLanguage(lang) {
            if (lang === "") {
                // Unraid has just written the previous locale cookie.
                remember(jQuery.cookie("locale"));
            } else if (!validLocale(lang)) {
                // Restore the remembered language if the cookie was lost.
                lang = recalled() || lang;
            } else {
                remember(lang);
            }

            return original.call(this, lang);
        }

        wrappedSwitchLanguage.topaLanguageFix = true;
        window.switchLanguage = wrappedSwitchLanguage;
        return true;
    }

    if (!install()) {
        document.addEventListener("DOMContentLoaded", install, {once: true});
    }
})();
