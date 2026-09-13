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
