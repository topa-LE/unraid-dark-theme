# topa-LE Pop-up-Box

## Zweck

Einheitlicher Designstandard fuer kleine schwebende Elemente
im topa-LE Unraid Dark Theme.

Beispiele:
- Font-Switcher-Auswahlmenue
- Unraid-Header-Tooltips
- Unassigned-Devices-Info-Tooltips
- Zukuenftige VM-Formular-Dropdowns
- Weitere Pop-up- und Auswahlmenues

## Verbindliche Grundfarben

| Eigenschaft | Font-Switcher | Tooltips |
|---|---|---|
| Hintergrund | #192125 | #192125 |
| Schriftfarbe | #d6dde3 | #d6dde3 |
| Rahmenfarbe | #2b3439 | #405158 |
| Rahmenstaerke | 1px | 1px |
| Eckenradius | 8px | 8px |
| Schatten | none | none |

## Font-Switcher

Die bestehende Font-Switcher-Gestaltung bleibt unveraendert.

CSS-Referenz:

    #topa-font-menu {
        background: #192125 !important;
        color: #d6dde3 !important;
        border: 1px solid #2b3439 !important;
        border-radius: 8px;
        box-shadow: none !important;
    }

Die Rahmenfarbe #2b3439 ist fuer den Font-Switcher
bewusst festgelegt und darf nicht automatisch durch
die hellere Tooltip-Rahmenfarbe ersetzt werden.

## Tooltips

Die Tooltip-Gestaltung wurde am 14.10.2026
im Chrome-JavaScript-Livetest freigegeben.

CSS-Referenz:

    background: #192125 !important;
    color: #d6dde3 !important;
    border: 1px solid #405158 !important;
    border-radius: 8px !important;
    box-shadow: none !important;

Die hellere Rahmenfarbe #405158 sorgt fuer eine
bessere Erkennbarkeit der kleinen Tooltip-Boxen.

## Bereits integrierte Tooltip-Selektoren

Unraid 7.3.3 Header, Reka UI:

    body.dark .bg-popover[data-state][data-side]

Unassigned Devices und klassische Unraid-Info-Tooltips:

    a.info span.help-content
    a.info span

Weitere Tooltip-Systeme sind im gemeinsamen
Tooltip-Block in css/overrides.css zusammengefasst.

GitHub-Referenz:

    fd87f7b - style: unify tooltip colors with font switcher

## Zukuenftige Dropdown- und Pop-up-Elemente

Die Grundfarben dienen als Designvorlage fuer
weitere kleine schwebende Oberflaechenelemente.

Die Rahmenfarbe wird passend zum Element gewaehlt:

- Font-Switcher: #2b3439
- Tooltips: #405158
- Weitere Dropdowns: erst nach Sichtpruefung festlegen

Bestehende Funktionen und Auswahlmoeglichkeiten
duerfen durch die Gestaltung nicht beeintraechtigt werden.

## Gestaltungs- und Projektregeln

1. Vorhandene CSS-Selektoren zuerst ermitteln.
2. Optische Aenderungen zuerst in Chrome live testen.
3. Freigabe durch den Nutzer abwarten.
4. Danach bestehende Regeln in css/overrides.css anpassen.
5. Doppelte und widerspruechliche CSS-Regeln vermeiden.
6. Commit und Push ueber die Build-Workstation.
7. Deployment ueber den regulaeren GitHub-Bootstrap.
8. Font-Switcher-Rahmenfarbe unveraendert lassen.

## Abgrenzung zur Content-Box

Diese Referenz gilt fuer kleine schwebende Elemente.

Groessere Inhalts- und Formularbereiche verwenden
den separaten Standard aus:

    docs/unraid-content-box.md

## Projektkonvention

Die Anweisung "topa-LE Pop-up-Box verwenden"
bezeichnet diesen dokumentierten Designstandard.

Die konkreten Selektoren, Abmessungen und
Interaktionen werden je Unraid-Komponente
separat geprueft.
