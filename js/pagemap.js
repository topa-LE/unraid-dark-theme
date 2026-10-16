/*
 * topa-LE Unraid Dark Theme
 * PageMap Dashboard
 *
 * Transform the original Unraid sitemap into a searchable,
 * balanced dashboard without modifying the original links.
 */

(() => {
    'use strict';

    const DASHBOARD_ID = 'topa-le-pagemap-dashboard';
    const SOURCE_SELECTOR =
        '#displaybox > .content .js-fill-available-height';

    const ICONS = {
        dashboard: 'fa-dashboard',
        main: 'fa-hdd-o',
        shares: 'fa-folder-open-o',
        users: 'fa-users',
        settings: 'fa-cogs',
        plugins: 'fa-puzzle-piece',
        docker: 'fa-cubes',
        vms: 'fa-desktop',
        tools: 'fa-wrench',
        stats: 'fa-bar-chart',
        apps: 'fa-th-large',
        help: 'fa-question-circle',
        system: 'fa-server'
    };

    let scheduled = false;

    function isPageMap() {
        return window.location.pathname.replace(/\/+$/, '') ===
            '/Tools/PageMap';
    }

    function iconFor(title) {
        const key = title.toLowerCase().replace(/[^a-z]/g, '');

        return ICONS[key] || 'fa-sitemap';
    }

    function collectGroups(source) {
        const groups = [];
        let currentGroup = null;

        function walk(list, depth) {
            for (const node of list.children) {
                if (node.tagName === 'UL') {
                    walk(node, depth + 1);
                    continue;
                }

                if (node.tagName !== 'A' || !node.hasAttribute('href')) {
                    continue;
                }

                const title = node.textContent.trim();
                const href = node.getAttribute('href');

                if (depth === 1) {
                    currentGroup = {
                        title,
                        href,
                        links: []
                    };

                    groups.push(currentGroup);
                } else if (currentGroup) {
                    currentGroup.links.push({
                        title,
                        href,
                        depth
                    });
                }
            }
        }

        for (const list of source.children) {
            if (list.tagName === 'UL') {
                walk(list, 1);
            }
        }

        return groups;
    }

    function createLink(item, className) {
        const link = document.createElement('a');

        link.className = className;
        link.setAttribute('href', item.href);
        link.textContent = item.title;

        return link;
    }

    function createCard(group) {
        const card = document.createElement('section');
        card.className = 'topa-pagemap-card';

        const heading = createLink(
            group,
            'topa-pagemap-card-title'
        );

        const icon = document.createElement('i');
        icon.className = 'fa ' + iconFor(group.title);
        icon.setAttribute('aria-hidden', 'true');

        heading.prepend(icon);
        card.appendChild(heading);

        const links = document.createElement('div');
        links.className = 'topa-pagemap-links';

        for (const item of group.links) {
            const link = createLink(
                item,
                'topa-pagemap-link topa-pagemap-level-' + item.depth
            );

            links.appendChild(link);
        }

        card.appendChild(links);

        return card;
    }

    function columnCount() {
        if (window.innerWidth < 760) return 1;
        if (window.innerWidth < 1150) return 2;

        return 3;
    }

    function balanceCards(grid) {
        const cards = Array.from(
            grid.querySelectorAll('.topa-pagemap-card')
        );

        if (!cards.length) return;

        const columns = columnCount();

        grid.style.setProperty(
            '--topa-pagemap-columns',
            String(columns)
        );

        const measuringColumn = document.createElement('div');
        measuringColumn.className = 'topa-pagemap-column';
        measuringColumn.style.visibility = 'hidden';

        grid.replaceChildren(measuringColumn);

        for (const card of cards) {
            measuringColumn.appendChild(card);
        }

        const measurements = cards.map(card => ({
            card,
            height: card.hidden
                ? 0
                : Math.max(
                    card.getBoundingClientRect().height,
                    card.scrollHeight
                )
        }));

        measurements.sort((a, b) => b.height - a.height);

        grid.replaceChildren();

        const containers = [];
        const heights = [];

        for (let i = 0; i < columns; i++) {
            const column = document.createElement('div');
            column.className = 'topa-pagemap-column';

            containers.push(column);
            heights.push(0);
            grid.appendChild(column);
        }

        for (const item of measurements) {
            const target = heights.indexOf(Math.min(...heights));

            containers[target].appendChild(item.card);

            if (!item.card.hidden) {
                heights[target] += item.height + 18;
            }
        }
    }

    function install() {
        if (!isPageMap()) return;

        const source = document.querySelector(SOURCE_SELECTOR);

        if (!source || document.getElementById(DASHBOARD_ID)) {
            return;
        }

        const groups = collectGroups(source);

        if (!groups.length) return;

        const originalLinks = Array.from(
            source.querySelectorAll('a[href]')
        ).map(link => link.getAttribute('href'));

        const collectedLinks = groups.flatMap(group => [
            group.href,
            ...group.links.map(link => link.href)
        ]);

        const sortedOriginal = [...originalLinks].sort();
        const sortedCollected = [...collectedLinks].sort();

        if (
            sortedOriginal.length !== sortedCollected.length ||
            sortedOriginal.some(
                (href, index) => href !== sortedCollected[index]
            )
        ) {
            console.error(
                '[topa-LE PageMap] Linkvergleich fehlgeschlagen. ' +
                'Original-Sitemap bleibt erhalten.',
                {
                    original: originalLinks.length,
                    dashboard: collectedLinks.length
                }
            );
            return;
        }

        const dashboard = document.createElement('div');
        dashboard.id = DASHBOARD_ID;

        const header = document.createElement('div');
        header.className = 'topa-pagemap-header';

        const title = document.createElement('h2');
        title.className = 'topa-pagemap-title';
        title.textContent = 'Seitenverzeichnis';

        const count = document.createElement('span');
        count.className = 'topa-pagemap-count';

        const totalLinks = groups.reduce(
            (sum, group) => sum + group.links.length + 1,
            0
        );

        count.textContent =
            totalLinks + ' Seiten · ' + groups.length + ' Bereiche';

        const search = document.createElement('input');
        search.type = 'search';
        search.className = 'topa-pagemap-search';
        search.placeholder = 'Seiten durchsuchen …';
        search.setAttribute('aria-label', 'Seiten durchsuchen');

        header.append(title, count, search);
        dashboard.appendChild(header);

        const grid = document.createElement('div');
        grid.className = 'topa-pagemap-grid';

        for (const group of groups) {
            grid.appendChild(createCard(group));
        }

        dashboard.appendChild(grid);

        search.addEventListener('input', () => {
            const term = search.value.trim().toLocaleLowerCase();

            for (const card of grid.querySelectorAll(
                '.topa-pagemap-card'
            )) {
                const heading = card.querySelector(
                    '.topa-pagemap-card-title'
                );

                const titleMatches = heading.textContent
                    .toLocaleLowerCase()
                    .includes(term);

                let visible = 0;

                for (const link of card.querySelectorAll(
                    '.topa-pagemap-link'
                )) {
                    const matches = !term ||
                        titleMatches ||
                        link.textContent.toLocaleLowerCase().includes(term);

                    link.hidden = !matches;

                    if (matches) visible++;
                }

                card.hidden = Boolean(term) &&
                    !titleMatches &&
                    visible === 0;
            }

            balanceCards(grid);
        });

        source.parentNode.insertBefore(dashboard, source);
        source.hidden = true;

        balanceCards(grid);

        let previousColumns = columnCount();

        window.addEventListener('resize', () => {
            const nextColumns = columnCount();

            if (nextColumns !== previousColumns) {
                previousColumns = nextColumns;
                balanceCards(grid);
            }
        }, { passive: true });
    }

    function scheduleInstall() {
        if (scheduled) return;

        scheduled = true;

        requestAnimationFrame(() => {
            scheduled = false;
            install();
        });
    }

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            scheduleInstall,
            { once: true }
        );
    } else {
        scheduleInstall();
    }

    const observer = new MutationObserver(scheduleInstall);

    observer.observe(document.documentElement, {
        childList: true,
        subtree: true
    });
})();
