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
            Math.min(screen.availHeight, 720),
            Math.min(screen.availWidth, 1280)
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
