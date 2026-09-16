/* ==========================================================
   Dynamix System Stats
   Keep Highcharts inside the available graph wrapper.
   ========================================================== */

(() => {
    'use strict';

    function resizeSystemStatsChart() {
        const graph = document.querySelector('#sys.graph1');

        if (!graph) {
            return;
        }

        const container = graph.querySelector('.highcharts-container');

        if (!container) {
            return;
        }

        graph.style.setProperty('width', '100%', 'important');
        graph.style.setProperty('max-width', '100%', 'important');

        container.style.setProperty('width', '100%', 'important');
        container.style.setProperty('max-width', '100%', 'important');

        if (
            window.Highcharts &&
            Array.isArray(window.Highcharts.charts)
        ) {
            const chart = window.Highcharts.charts.find(
                item => item && item.renderTo === container
            );

            if (
                chart &&
                typeof chart.setSize === 'function' &&
                graph.clientWidth > 0 &&
                chart.chartWidth !== graph.clientWidth
            ) {
                chart.setSize(
                    graph.clientWidth,
                    chart.chartHeight,
                    false
                );
            }
        }
    }

    function initSystemStatsTheme() {
        resizeSystemStatsChart();

        const observer = new MutationObserver(() => {
            resizeSystemStatsChart();
        });

        observer.observe(document.body, {
            childList: true,
            subtree: true
        });

        window.addEventListener(
            'resize',
            resizeSystemStatsChart,
            { passive: true }
        );
    }

    if (document.readyState === 'loading') {
        document.addEventListener(
            'DOMContentLoaded',
            initSystemStatsTheme,
            { once: true }
        );
    } else {
        initSystemStatsTheme();
    }
})();
