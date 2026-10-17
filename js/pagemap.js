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

    function installNavigationIcon() {
        const navigation = document.querySelector('#menu .nav-tile.right');

        if (!navigation ||
            document.getElementById('topa-le-pagemap-nav')) {
            return;
        }

        const item = document.createElement('div');
        item.id = 'topa-le-pagemap-nav';
        item.className = 'nav-item topa-le-pagemap-nav util';

        const link = document.createElement('a');
        link.href = '/Tools/PageMap';
        link.title = 'PageMap – Seitenverzeichnis';
        link.setAttribute('aria-label', 'PageMap – Seitenverzeichnis');

        const icon = document.createElement('b');
        icon.className = 'fa fa-sitemap system';
        icon.setAttribute('aria-hidden', 'true');

        const label = document.createElement('span');
        label.textContent = 'PageMap';

        link.append(icon, label);
        item.appendChild(link);
        navigation.appendChild(item);
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


    // DE: Gepruefte Kartenstruktur aus der finalen Browser-Vorschau.
    // EN: Verified card layout from the final browser preview.
    const CARD_LAYOUT = [
    {
        "title": "Dashboard",
        "icon": "fa fa-dashboard",
        "links": [
            "/DashStats"
        ]
    },
    {
        "title": "UserPreferences",
        "icon": "fa fa-sitemap",
        "links": [
            "/Confirmations",
            "/Console",
            "/DisplaySettings",
            "/Scheduler",
            "/MoverSettings",
            "/TrimSettings"
        ]
    },
    {
        "title": "Notifications",
        "icon": "fa fa-bell-o",
        "links": [
            "/Notifications",
            "/SmtpSettings",
            "/NotificationAgents"
        ]
    },
    {
        "title": "CPUset",
        "icon": "fa fa-sitemap",
        "links": [
            "/CPUvms",
            "/CPUpin",
            "/CPUisol"
        ]
    },
    {
        "title": "Network & Remote Access",
        "icon": "fa fa-globe",
        "links": [
            "/FTP",
            "/OutgoingProxy",
            "/SyslogSettings"
        ]
    },
    {
        "title": "Stats",
        "icon": "fa fa-bar-chart",
        "links": [
            "/SystemDisks",
            "/SystemStats",
            "/StatSettings",
            "/TempSettings"
        ]
    },
    {
        "title": "ManagementAccess",
        "icon": "fa fa-sitemap",
        "links": [
            "/ApiStatus",
            "/Connect",
            "/ApiKeys"
        ]
    },
    {
        "title": "Wizards",
        "icon": "fa fa-sitemap",
        "links": [
            "/OnboardingWizard",
            "/InternalBootWizard"
        ]
    },
    {
        "title": "Users",
        "icon": "fa fa-users",
        "links": [
            "/UserList",
            "/UserAdd",
            "/UserEdit"
        ]
    },
    {
        "title": "Docker",
        "icon": "fa fa-cubes",
        "links": [
            "/DockerContainers",
            "/dockerUpdateApps",
            "/DockerSafeNewPerms",
            "/DockerSettings"
        ]
    },
    {
        "title": "SystemInformation",
        "icon": "fa fa-sitemap",
        "links": [
            "/SystemProfiler",
            "/Overview",
            "/Bios",
            "/Motherboard",
            "/Processor",
            "/CacheMemory",
            "/MemorySummary",
            "/MemoryDevices",
            "/Ethernet"
        ]
    },
    {
        "title": "VPN",
        "icon": "fa fa-shield",
        "links": [
            "/Tailscale",
            "/VPNmanager",
            "/WG0"
        ]
    },
    {
        "title": "WebGui",
        "icon": "fa fa-sitemap",
        "links": [
            "/Language",
            "/PHPsettings",
            "/PageMap",
            "/Vars"
        ]
    },
    {
        "title": "UnassignedDevicesSettings",
        "icon": "fa fa-puzzle-piece",
        "links": [
            "/UnassignedDevicesCommon",
            "/UnassignedDevicesSMB",
            "/UnassignedDevicesNFS",
            "/UnassignedDevicesPassword",
            "/UnassignedDevicesUUID",
            "/UnassignedDevicesZFS",
            "/UnassignedDevicesRemoteTest"
        ]
    },
    {
        "title": "NetworkSettings",
        "icon": "fa fa-sitemap",
        "links": [
            "/Eth0",
            "/NetworkExtra",
            "/RoutingTable"
        ]
    },
    {
        "title": "UNRAID-OS",
        "icon": "fa fa-sitemap",
        "links": [
            "/Diagnostics",
            "/HardwareProfile",
            "/LogViewer",
            "/NewConfig",
            "/NewPerms",
            "/Processes",
            "/SysDevs",
            "/SysDrivers",
            "/Syslog",
            "/Terminal"
        ]
    },
    {
        "title": "NFS & SMB",
        "icon": "fa fa-sitemap",
        "links": [
            "/NFS",
            "/SMB",
            "/SMBsettings",
            "/SMBExtras",
            "/SMBWorkGroup"
        ]
    },
    {
        "title": "Shares",
        "icon": "fa fa-folder-open-o",
        "links": [
            "/ShareList",
            "/DiskList",
            "/ShareSettings"
        ]
    },
    {
        "title": "PowerMode",
        "icon": "fa fa-sitemap",
        "links": [
            "/PowerModeCpu",
            "/PowerModeButton"
        ]
    },
    {
        "title": "About",
        "icon": "fa fa-sitemap",
        "links": [
            "/Update",
            "/Downgrade",
            "/Registration",
            "/InstallKey",
            "/Credits",
            "/EULA"
        ]
    },
    {
        "title": "UPSsettings",
        "icon": "fa fa-sitemap",
        "links": [
            "/UPSdetails",
            "/VMSettings"
        ]
    },
    {
        "title": "Parity",
        "icon": "fa fa-hdd-o",
        "links": [
            "/ParityCheck",
            "/Parity.check.tuning",
            "/Parity.check.problems"
        ]
    },
    {
        "title": "Array & Boot",
        "icon": "fa fa-hdd-o",
        "links": [
            "/ArrayDevices",
            "/CacheDevices",
            "/BootDevice",
            "/UnassignedDevices",
            "/ArrayOperation",
            "/BootParameters"
        ]
    },
    {
        "title": "System Configuration",
        "icon": "fa fa-cogs",
        "links": [
            "/DateTime",
            "/DiskSettings",
            "/Identification"
        ]
    },
    {
        "title": "Plugins",
        "icon": "fa fa-puzzle-piece",
        "links": [
            "/PluginInstall",
            "/PluginsError"
        ]
    },
    {
        "title": "Utilities",
        "icon": "fa fa-sitemap",
        "links": [
            "/AutoUpdateApps",
            "/AutoUpdate",
            "/CleanUpAppdata",
            "/FixProblems",
            "/ca_settings",
            "/corefreq",
            "/corefreqMain",
            "/corefreqModules",
            "/snmp"
        ]
    }
];

    // DE: Unraid bleibt die Quelle fuer vorhandene Menuepunkte.
    // EN: Unraid remains the source of available menu entries.
    function transformGroups(sourceGroups) {
        const available = new Map();
        const originalHeadings = new Map();

        for (const group of sourceGroups) {
            originalHeadings.set(group.href, group);

            for (const link of group.links) {
                if (!available.has(link.href)) {
                    available.set(link.href, link);
                }
            }
        }

        const assigned = new Set();
        const result = [];

        for (const definition of CARD_LAYOUT) {
            const links = [];

            for (const href of definition.links) {
                const item = available.get(href);

                if (!item || assigned.has(href)) continue;

                links.push({
                    title: item.title,
                    href: item.href,
                    depth: item.depth
                });

                assigned.add(href);
            }

            if (!links.length) continue;

            const original = sourceGroups.find(
                group => group.title === definition.title
            );

            result.push({
                title: definition.title,
                href: original ? original.href : null,
                icon: definition.icon,
                links
            });
        }

        // DE: Zusaetzliche Plugin-Seiten nicht verlieren.
        // EN: Preserve additional pages supplied by installed plugins.
        const ignored = new Set([
            '/LanguageButton',
            '/TempButton',
            '/gui_search',
            '/LogoutButton',
            '/BrowseButton',
            '/FeedbackButton',
            '/InfoButton',
            '/LogButton',
            '/HelpButton',
            '/Parity.check.refresh',
            '/CA_notices',
            '/PluginHelpers'
        ]);

        // DE: Nicht zugeordnete Plugin-Seiten nach Hauptbereich gruppieren.
        // EN: Group unassigned plugin pages by their original top-level area.
        for (const group of sourceGroups) {
            const additional = [];

            for (const item of group.links) {
                if (assigned.has(item.href) ||
                    ignored.has(item.href)) {
                    continue;
                }

                assigned.add(item.href);
                additional.push(item);
            }

            if (!additional.length) continue;

            result.push({
                title: group.title + ' – Additional',
                href: null,
                icon: 'fa ' + iconFor(group.title),
                links: additional
            });
        }

        return result;
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

        // DE: Nur originale Kartenueberschriften sind Links.
        // EN: Only original card headings are clickable links.
        const heading = group.href
            ? createLink(group, 'topa-pagemap-card-title')
            : document.createElement('div');

        if (!group.href) {
            heading.className = 'topa-pagemap-card-title';
            heading.textContent = group.title;
        }

        const icon = document.createElement('i');
        icon.className = group.icon || 'fa ' + iconFor(group.title);
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

            link.style.fontSize = '15px';
            link.style.paddingLeft = '5px';
            link.style.lineHeight = '1.5';
            links.appendChild(link);
        }

        card.appendChild(links);

        return card;
    }

    function columnCount() {
        if (window.innerWidth < 760) return 1;
        if (window.innerWidth < 1050) return 2;
        if (window.innerWidth < 1400) return 3;

        return 4;
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

        const groups = transformGroups(collectGroups(source));

        if (!groups.length) return;

        // DE: Die finale Ansicht zeigt bewusst nur echte Seiten.
        // EN: The final view intentionally excludes UI controls.

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
            installNavigationIcon();
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
