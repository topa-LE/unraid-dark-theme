(() => {
    'use strict';

    const WRAPPER_ID = 'topa-le-array-spin-wrapper';

    function applyArraySpinWrapper() {
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
