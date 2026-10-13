/*
 * topa-LE Unraid Dark Theme
 * Font Switcher - Phase 3B
 *
 * Local font selection with persistent browser preference.
 */

(function topaFontSwitcher() {
    "use strict";

    const ID = "topa-font-switcher";

    const fonts = [
        "Standard (Unraid)",
        "Titillium Web",
        "Inter",
        "Maven Pro",
        "Saira Condensed",
        "Roboto Condensed",
        "Ubuntu Condensed",
        "Dosis",
        "Cuprum",
        "Play"
    ];


    const STORAGE_KEY = "topa-font-choice";
    const FONT_VALUES = {
        "Standard (Unraid)": '"topa-unraid-clear-sans", sans-serif',
        "Titillium Web": '"Titillium Web", sans-serif',
        "Inter": '"Inter", sans-serif',
        "Maven Pro": '"Maven Pro", sans-serif',
        "Saira Condensed": '"Saira Condensed", sans-serif',
        "Roboto Condensed": '"Roboto Condensed", sans-serif',
        "Ubuntu Condensed": '"Ubuntu Condensed", sans-serif',
        "Dosis": '"Dosis", sans-serif',
        "Cuprum": '"Cuprum", sans-serif',
        "Play": '"Play", sans-serif'
    };

    function getChoice() {
        try {
            const saved = localStorage.getItem(STORAGE_KEY);
            if (Object.prototype.hasOwnProperty.call(FONT_VALUES, saved)) {
                return saved;
            }
        } catch (error) {
            // Storage may be disabled.
        }
        return "Titillium Web";
    }

    function applyChoice(choice) {
        const html = document.documentElement;

        html.setAttribute(
            "data-topa-font",
            choice === "Standard (Unraid)" ? "standard" : "custom"
        );
        html.style.setProperty("--topa-font-family", FONT_VALUES[choice]);
    }

    function saveChoice(choice) {
        try {
            localStorage.setItem(STORAGE_KEY, choice);
        } catch (error) {
            // Switching still works for the current page.
        }
    }

    function updateChecks(menu, choice) {
        menu.querySelectorAll(".topa-font-menu-item").forEach((item) => {
            item.setAttribute(
                "aria-checked",
                item.textContent === choice ? "true" : "false"
            );
        });
    }

    function install() {
        const selectedFont = getChoice();
        applyChoice(selectedFont);
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
        button.setAttribute("aria-haspopup", "true");
        button.setAttribute("aria-expanded", "false");

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
            "font-family: Titillium Web, sans-serif !important",
            "font-size: 13px !important",
            "font-weight: 600 !important",
            "line-height: 1 !important",
            "box-shadow: none !important",
            "text-transform: none !important",
            "cursor: pointer !important"
        ].join(";") + ";";

        const menu = document.createElement("div");
        menu.className = "topa-font-menu";
        menu.id = "topa-font-menu";
        menu.hidden = true;
        menu.setAttribute("aria-label", "Schriftart auswählen");

        button.setAttribute("aria-controls", menu.id);

        const title = document.createElement("div");
        title.className = "topa-font-menu-title";
        title.textContent = "Schriftart auswählen";
        menu.appendChild(title);

        const divider = document.createElement("div");
        divider.className = "topa-font-menu-divider";
        menu.appendChild(divider);

        fonts.forEach((font, index) => {
            const item = document.createElement("button");
            item.type = "button";
            item.className = "topa-font-menu-item";
            item.textContent = font;
            item.setAttribute(
                "aria-checked",
                font === selectedFont ? "true" : "false"
            );

            item.addEventListener("click", () => {
                applyChoice(font);
                saveChoice(font);
                updateChecks(menu, font);
                closeMenu();
                button.focus();
            });

            menu.appendChild(item);
        });

        function closeMenu() {
            menu.hidden = true;
            button.setAttribute("aria-expanded", "false");
        }

        function positionMenu() {
            const rect = button.getBoundingClientRect();
            menu.style.top = `${rect.bottom + 12}px`;
            menu.style.right = `${Math.max(8, window.innerWidth - rect.right)}px`;
        }

        button.addEventListener("click", () => {
            const shouldOpen = menu.hidden;
            if (shouldOpen) positionMenu();
            menu.hidden = !shouldOpen;
            button.setAttribute(
                "aria-expanded",
                shouldOpen ? "true" : "false"
            );
        });

        document.addEventListener("click", (event) => {
            if (!root.contains(event.target) &&
                !menu.contains(event.target)) {
                closeMenu();
            }
        });

        document.addEventListener("keydown", (event) => {
            if (event.key === "Escape" && !menu.hidden) {
                closeMenu();
                button.focus();
            }
        });

        root.appendChild(button);
        language.parentElement.insertBefore(root, language);
        document.body.appendChild(menu);

        window.addEventListener("resize", () => {
            if (!menu.hidden) positionMenu();
        });
        window.addEventListener("scroll", () => {
            if (!menu.hidden) positionMenu();
        }, true);

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
