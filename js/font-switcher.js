/*
 * topa-LE Unraid Dark Theme
 * Font Switcher – Phase 1
 *
 * Compact Aa button in the authenticated WebGUI.
 * Font selection and dropdown will follow later.
 */

(function topaFontSwitcher() {
    "use strict";

    const ID = "topa-font-switcher";

    function install() {
        const language = document.querySelector(
            ".nav-item.LanguageButton.util"
        );

        if (!language || !language.parentElement) {
            return false;
        }

        if (document.getElementById(ID)) {
            return true;
        }

        const root = document.createElement("div");
        root.id = ID;

        Object.assign(root.style, {
            position: "relative",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            flex: "0 0 34px",
            width: "34px",
            height: "40px",
            margin: "0",
            padding: "0",
            background: "transparent",
            border: "none",
            boxShadow: "none"
        });

        const button = document.createElement("button");
        button.type = "button";
        button.textContent = "Aa";
        button.title = "Schriftart auswählen";
        button.setAttribute(
            "aria-label",
            "Schriftart auswählen"
        );

        button.style.cssText = [
            "display: flex !important",
            "align-items: center !important",
            "justify-content: center !important",
            "width: 28px !important",
            "height: 28px !important",
            "min-width: 28px !important",
            "min-height: 28px !important",
            "margin: 0 !important",
            "padding: 0 !important",
            "background: #252d30 !important",
            "color: #dc9b66 !important",
            "border: 1px solid #303b40 !important",
            "border-radius: 5px !important",
            "font-family: Arial, sans-serif !important",
            "font-size: 13px !important",
            "font-weight: 600 !important",
            "line-height: 1 !important",
            "box-shadow: none !important",
            "text-transform: none !important",
            "cursor: default !important"
        ].join(";") + ";";

        root.appendChild(button);
        language.parentElement.insertBefore(root, language);

        return true;
    }

    if (install()) {
        return;
    }

    const observer = new MutationObserver(() => {
        if (install()) {
            observer.disconnect();
        }
    });

    observer.observe(document.documentElement, {
        childList: true,
        subtree: true
    });

    document.addEventListener("DOMContentLoaded", install, {
        once: true
    });
})();
