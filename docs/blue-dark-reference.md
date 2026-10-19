# Blue Dark – freigegebene Live-Referenz

## Stand

Freigegeben auf Unraid .12 nach den Browser-Live-Tests
der Schritte 1150 bis 1159.

Gray Dark bleibt unverändert.

## Blue-Dark-Farben

body.dark:
- radial-gradient(#5e7287 0%, #354656 48%, #0a0d0f 100%)

body.dark #footer:
- radial-gradient(#5e7287 0%, #354656 48%, #0a0d0f 100%)

body.dark table.unraid tbody:
- ungerade Zeilen: #263340
- gerade Zeilen: #303f4f

Alle vier CSS-Regeln wurden im Live-Test mit !important verwendet.

## Endgültig freigegebene Farbpalette

SVG:
- width: 19
- height: 19
- viewBox: 0 0 24 24

Kreise:
- cx=12, cy=12, r=10, fill=#d6dde3
- cx=7.5, cy=8, r=3, fill=#e95c62
- cx=15.5, cy=7.5, r=3, fill=#f0bc48
- cx=17, cy=15, r=3, fill=#57b985
- cx=8.5, cy=16, r=3, fill=#559ee6
- cx=12, cy=12, r=1.5, fill=#29363c

Das SVG-Design ist endgültig freigegeben und darf nicht
ohne erneute Nutzerfreigabe verändert werden.

## Position

- Links direkt neben dem Aa-Schalter.
- Button: 23 x 23 Pixel.
- Containergeometrie entsprechend dem Aa-Switcher.
- Schritt 1159: Palette und Aa exakt ausgerichtet.
- Oberkante: 100 px
- Mitte: 111.5 px
- Höhe: 23 px
- Abweichung: 0.00 px
- Keine feste Transform-Verschiebung als dauerhafte Lösung.

## Geplante Architektur

css/blue-dark.css:
- ausschließlich Blue-Dark-Farbregeln

css/theme-switcher.css:
- Gestaltung der Palette und des Dropdown-Menüs

js/theme-switcher.js:
- Auswahl, Aktivierung und Speicherung

Theme-Auswahl:
- Gray Dark
- Blue Dark
- später um weitere Varianten erweiterbar

## Unverändert lassen

- js/font-switcher.js
- css/font-switcher.css
- Login und Passwort-Reset
- bestehende Gray-Dark-Regeln

## Vorgehen

1. Browser-Live-Test.
2. Nutzerfreigabe.
3. Gezielte Repository-Änderung.
4. Syntax- und Diff-Prüfung.
5. Commit und Push.
6. Testinstallation und Regressionstest.

Diese Datei ist ausschließlich eine Referenz.
Sie aktiviert keine Theme-Umschaltung.
