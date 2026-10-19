/*
 * topa-LE Unraid Dark Theme
 * Theme Switcher – Gray Dark / Blue Dark
 *
 * Independent of the font switcher.
 * Only controls the data-topa-theme attribute.
 */

(function topaThemeSwitcher() {
    "use strict";

    const ID = "topa-theme-switcher";
    const STORAGE_KEY = "topa-theme-choice";

    const themes = [
        { label: "Gray Dark", value: "gray-dark" },
        { label: "Blue Dark", value: "blue-dark" }
    ];

    const paletteSVG = `
        <svg xmlns="http://www.w3.org/2000/svg"
             width="19" height="19"
             viewBox="0 0 24 24"
             aria-hidden="true">
            <circle cx="12" cy="12" r="10" fill="#d6dde3"/>
            <circle cx="7.5" cy="8" r="3" fill="#e95c62"/>
            <circle cx="15.5" cy="7.5" r="3" fill="#f0bc48"/>
            <circle cx="17" cy="15" r="3" fill="#57b985"/>
            <circle cx="8.5" cy="16" r="3" fill="#559ee6"/>
            <circle cx="12" cy="12" r="1.5" fill="#29363c"/>
        </svg>
    `;

    function getChoice() {
        try {
            const saved = localStorage.getItem(STORAGE_KEY);
            if (themes.some((theme) => theme.value === saved)) {
                return saved;
            }
        } catch (error) {
            // Storage may be disabled.
        }
        return "gray-dark";
    }

    function applyChoice(choice) {
        document.documentElement.setAttribute(
            "data-topa-theme",
            choice === "blue-dark" ? "blue-dark" : "gray-dark"
        );
    }

    function saveChoice(choice) {
        try {
            localStorage.setItem(STORAGE_KEY, choice);
        } catch (error) {
            // Switching still works for the current page.
        }
    }

    function updateChecks(menu, choice) {
        menu.querySelectorAll(".topa-theme-menu-item").forEach((item) => {
            item.setAttribute(
                "aria-checked",
                item.dataset.theme === choice ? "true" : "false"
            );
        });
    }

    function install() {
        applyChoice(getChoice());

        const fontSwitcher = document.getElementById(
            "topa-font-switcher"
        );

        if (!fontSwitcher || !fontSwitcher.parentElement) {
            return false;
        }

        if (document.getElementById(ID)) {
            return true;
        }

        const root = document.createElement("div");
        root.id = ID;

        // Match the existing Aa switcher instead of guessing dimensions.
        const fontContainerCSS = getComputedStyle(fontSwitcher);
        const matchingProperties = [
            "width", "height", "min-width", "min-height",
            "max-width", "max-height",
            "padding", "margin",
            "background", "border", "border-radius",
            "box-shadow", "box-sizing",
            "display", "align-items", "justify-content",
            "vertical-align", "position"
        ];

        matchingProperties.forEach((property) => {
            root.style.setProperty(
                property,
                fontContainerCSS.getPropertyValue(property),
                "important"
            );
        });

        const button = document.createElement("button");
        button.type = "button";
        button.title = "Farbschema auswählen";
        button.setAttribute(
            "aria-label",
            "Farbschema auswählen"
        );
        button.setAttribute("aria-haspopup", "true");
        button.setAttribute("aria-expanded", "false");
        button.innerHTML = paletteSVG;

        // Reuse the actual Aa button appearance, keeping the palette SVG.
        const fontButton = fontSwitcher.querySelector("button") || fontSwitcher;
        const fontButtonCSS = getComputedStyle(fontButton);

        matchingProperties.forEach((property) => {
            button.style.setProperty(
                property,
                fontButtonCSS.getPropertyValue(property),
                "important"
            );
        });

        button.style.cursor = "pointer";

        // Match the approved live alignment with the Aa switcher.
        // The palette container is 40px high; Aa is 41px high.
        // A 0.5px vertical offset aligns both button centers.
        root.style.setProperty(
            "transform",
            "translateY(0.5px)",
            "important"
        );

        const menu = document.createElement("div");
        menu.id = "topa-theme-menu";
        menu.hidden = true;
        menu.setAttribute(
            "aria-label",
            "Farbschema auswählen"
        );

        button.setAttribute("aria-controls", menu.id);

        const title = document.createElement("div");
        title.className = "topa-theme-menu-title";
        title.textContent = "Farbschema auswählen";
        menu.appendChild(title);

        const divider = document.createElement("div");
        divider.className = "topa-theme-menu-divider";
        menu.appendChild(divider);

        themes.forEach((theme) => {
            const item = document.createElement("button");
            item.type = "button";
            item.className = "topa-theme-menu-item";
            item.textContent = theme.label;
            item.dataset.theme = theme.value;
            item.setAttribute(
                "aria-checked",
                theme.value === getChoice() ? "true" : "false"
            );

            item.addEventListener("click", () => {
                applyChoice(theme.value);
                saveChoice(theme.value);
                updateChecks(menu, theme.value);
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
            menu.style.right =
                `${Math.max(8, window.innerWidth - rect.right)}px`;
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
        fontSwitcher.parentElement.insertBefore(root, fontSwitcher);
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
