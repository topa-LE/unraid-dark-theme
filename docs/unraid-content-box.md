# topa-LE Content-Box

## Zweck

Einheitlicher Designstandard fuer zusammengehoerige Inhaltsbereiche
im topa-LE Unraid Dark Theme.

Beispiele:
- Docker-Container hinzufuegen und bearbeiten
- Docker-Installationsprotokolle
- Status- und Informationsbereiche
- Einstellungsformulare
- Text- und Inhaltsbereiche

## Verbindliche CSS-Gestaltung

```css
background: linear-gradient(
    180deg,
    rgba(46, 60, 68, 0.82) 0%,
    rgba(34, 47, 55, 0.90) 100%
) !important;

border: 1px solid rgb(21 24 25 / 22%) !important;
border-radius: 10px !important;
box-shadow: 0 10px 30px rgba(0, 0, 0, 0.34) !important;
padding: 14px 18px !important;
box-sizing: border-box !important;
```

## Variable Breite

Die Breite ist kein fester Bestandteil der Gestaltung.

- 850px: Docker-Eingabemasken
- Bis 1280px: groessere Inhaltsbereiche
- Andere Breiten je nach Seitenlayout

Beispiel fuer eine zentrierte Box:

```css
width: 100% !important;
max-width: 850px !important;
margin-left: auto !important;
margin-right: auto !important;
```

## Gestaltungsregeln

1. Zusammengehoerige Inhalte erhalten eine gemeinsame Content-Box.
2. Keine unnoetigen Einzelrahmen um jedes Eingabefeld.
3. Bestehende Eingabefelder und Funktionen bleiben erhalten.
4. CSS-Selektoren vor Aenderungen im Browser pruefen.
5. Neue Gestaltung zuerst in Chrome DevTools testen.
6. Nach Freigabe in css/overrides.css uebernehmen.
7. Deployment ueber GitHub und den regulaeren Theme-Updater.

## Bereits eingesetzte Selektoren

Docker-Installationsprotokoll:

```css
p#logBody.logLine fieldset.CMD
```

Docker-Container hinzufuegen/bearbeiten:

```css
form:has(> #configLocation):has(> #configLocationAdvanced)
```

## Projektkonvention

Die Anweisung "topa-LE Content-Box verwenden" bezeichnet
diesen einheitlichen Designstandard.

Breite, Positionierung und CSS-Selektoren werden fuer die
jeweilige Unraid-Seite separat festgelegt.
