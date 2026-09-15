(() => {
    'use strict';

    const WRAPPER_ID = 'topa-le-array-spin-wrapper';

    function fixArrayOpsSpacing() {
        const form = document.forms.arrayOps;

        if (!form) {
            return;
        }

        Array.from(form.children).forEach((element) => {
            if (
                element.tagName === 'P' &&
                !element.textContent.trim()
            ) {
                element.style.setProperty('margin', '0', 'important');
                element.style.setProperty('display', 'none', 'important');
            }
        });
    }

    function applyArraySpinWrapper() {
        fixArrayOpsSpacing();

        const button = document.getElementById('spinup-button');

        if (!button) {
            return;
        }

        const table = button.closest(
            'table.ArrayOperation-Table.array_status.noshift'
        );

        if (!table) {
            return;
        }

        if (table.parentElement && table.parentElement.id === WRAPPER_ID) {
            return;
        }

        const wrapper = document.createElement('div');
        wrapper.id = WRAPPER_ID;

        table.parentNode.insertBefore(wrapper, table);
        wrapper.appendChild(table);
    }

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            applyArraySpinWrapper,
            { once: true }
        );
    } else {
        applyArraySpinWrapper();
    }

    const observer = new MutationObserver(applyArraySpinWrapper);

    observer.observe(document.documentElement, {
        childList: true,
        subtree: true
    });
})();


/* topa-LE Community Apps category label
 * Hide the category pill when Community Apps supplies only &nbsp;.
 * Show it again when a real category name is present.
 */
(() => {
    const syncCommunityAppsCategory = () => {
        const el = document.querySelector(
            '.searchArea .category.categoryLine'
        );

        if (!el) {
            return;
        }

        const hasText = el.textContent.trim().length > 0;

        el.style.setProperty(
            'display',
            hasText ? 'inline-flex' : 'none',
            'important'
        );
    };

    const initCommunityAppsCategory = () => {
        if (window.topaCommunityAppsCategoryObserver) {
            window.topaCommunityAppsCategoryObserver.disconnect();
        }

        syncCommunityAppsCategory();

        const searchArea = document.querySelector('.searchArea');

        if (!searchArea) {
            return;
        }

        window.topaCommunityAppsCategoryObserver =
            new MutationObserver(syncCommunityAppsCategory);

        window.topaCommunityAppsCategoryObserver.observe(searchArea, {
            childList: true,
            characterData: true,
            subtree: true
        });
    };

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            initCommunityAppsCategory,
            { once: true }
        );
    } else {
        initCommunityAppsCategory();
    }
})();

/* topa-LE WebTerminal Popup Size - START */
document.addEventListener('DOMContentLoaded', function () {
    if (typeof window.openTerminal !== 'function') {
        return;
    }

    window.openTerminal = function(tag, name, more) {
        if (/MSIE|Edge/.test(navigator.userAgent)) {
            swal({
                title: "_(Unsupported Feature)_",
                text: "_(Sorry, this feature is not supported by MSIE/Edge)_.<br>_(Please try a different browser)_",
                type: 'error',
                html: true,
                animation: 'none',
                confirmButtonText: "_(Ok)_"
            });
            return;
        }

        name = name.replace(/[ #]/g, "_");

        tty_window = makeWindow(
            name + (more == '.log' ? more : ''),
            screen.availHeight,
            screen.availWidth
        );

        if (tty_window === null) {
            throw new Error('Failed to open terminal window');
        }

        var socket = ['ttyd', 'syslog'].includes(tag)
            ? '/webterminal/' + tag + '/'
            : '/logterminal/' + name + (more == '.log' ? more : '') + '/';

        $.get(
            '/webGui/include/OpenTerminal.php',
            {tag: tag, name: name, more: more},
            function() {
                setTimeout(function() {
                    tty_window.location = socket;
                    tty_window.focus();
                }, 200);
            }
        );
    };
});
/* topa-LE WebTerminal Popup Size - END */

/* topa-LE Share Settings Array Stop Notice - START */
document.addEventListener('DOMContentLoaded', function () {
    const notice = [...document.querySelectorAll('em')].find(el =>
        el.textContent.trim() === 'Zum Ändern muss das Array gestoppt sein'
    );

    if (notice) {
        notice.classList.add('notice', 'topa-array-stop-notice');
    }
});
/* topa-LE Share Settings Array Stop Notice - END */

/* topa-LE GUI Search Placeholder - START */
document.addEventListener('DOMContentLoaded', function () {
    const setupSearchBox = () => {
        const search = document.querySelector('#guiSearchBox');

        if (!search || search.dataset.topaSearchReady === '1') {
            return;
        }

        search.dataset.topaSearchReady = '1';
        search.setAttribute('placeholder', 'Suchbegriff hier eingeben ...');

        search.addEventListener('pointerdown', function () {
            search.classList.add('topa-search-user-active');
        });

        search.addEventListener('blur', function () {
            if (!search.value) {
                search.classList.remove('topa-search-user-active');
            }
        });
    };

    setupSearchBox();

    const observer = new MutationObserver(function () {
        setupSearchBox();
    });

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
});
/* topa-LE GUI Search Placeholder - END */

/* topa-LE OS Downgrade Release Notes - START */
(function () {
    function setupDowngradeReleaseNotes() {
        const root = document.querySelector('unraid-downgrade-os');

        if (!root) {
            return;
        }

        const releaseNote = [...root.querySelectorAll('span[role="button"]')]
            .find(el => el.textContent.trim().endsWith('Versionshinweise'));

        if (releaseNote) {
            releaseNote.classList.add('topa-downgrade-release-notes');
        }
    }

    document.addEventListener('DOMContentLoaded', setupDowngradeReleaseNotes);

    const observer = new MutationObserver(setupDowngradeReleaseNotes);

    observer.observe(document.body, {
        childList: true,
        subtree: true
    });
})();
/* topa-LE OS Downgrade Release Notes - END */

/* ==========================================================
   Header branding - storage icon
   ========================================================== */

(function topaHeaderStorageIcon() {
    function installStorageIcon() {
        const link = document.querySelector(
            'unraid-header-os-version a[aria-label="Unraid-Website besuchen"]'
        );

        if (!link || link.querySelector('.topa-storage-icon')) {
            return false;
        }

        const logo = link.querySelector('svg');

        if (!logo) {
            return false;
        }

        const icon = document.createElementNS(
            'http://www.w3.org/2000/svg',
            'svg'
        );

        icon.setAttribute('class', 'topa-storage-icon');
        icon.setAttribute('viewBox', '0 0 48 48');
        icon.setAttribute('aria-hidden', 'true');
        icon.setAttribute('focusable', 'false');

        icon.innerHTML = `
            <defs>
                <linearGradient
                    id="topa-header-storage-gradient"
                    x1="5"
                    y1="43"
                    x2="43"
                    y2="5"
                    gradientUnits="userSpaceOnUse">
                    <stop offset="0" stop-color="#e32929"></stop>
                    <stop offset="1" stop-color="#ff8d30"></stop>
                </linearGradient>
            </defs>

            <g
                fill="none"
                stroke="url(#topa-header-storage-gradient)"
                stroke-width="2.4"
                stroke-linecap="round"
                stroke-linejoin="round">
                <ellipse cx="24" cy="10" rx="16" ry="6"></ellipse>

                <path d="
                    M8 10v10
                    c0 3.3 7.2 6 16 6
                    s16-2.7 16-6V10
                "></path>

                <path d="
                    M8 20v10
                    c0 3.3 7.2 6 16 6
                    s16-2.7 16-6V20
                "></path>

                <path d="
                    M8 30v8
                    c0 3.3 7.2 6 16 6
                    s16-2.7 16-6v-8
                "></path>
            </g>
        `;

        link.insertBefore(icon, logo);
        return true;
    }

    if (installStorageIcon()) {
        return;
    }

    const observer = new MutationObserver(() => {
        if (installStorageIcon()) {
            observer.disconnect();
        }
    });

    observer.observe(document.documentElement, {
        childList: true,
        subtree: true
    });
})();
