# topa-LE Content-Box

## Verbindlicher Designstandard – FINAL

Status: Visuell freigegeben am 18.10.2026.

Diese Content-Box ist die verbindliche topa-LE Designvorlage
fuer zusammengehoerige Inhaltsbereiche.

Der dokumentierte Farbverlauf, Rahmen, Radius, Schatten und
Innenabstand sollen bei neuen Content-Boxen einheitlich
uebernommen werden.

### Schatten – finale Entscheidung

    box-shadow: 0 0 8px rgba(0, 0, 0, 0.16) !important;

Der Schatten ist bewusst dezent und symmetrisch:
- Horizontaler Versatz: 0 px
- Vertikaler Versatz: 0 px
- Unschaerfe: 8 px
- Deckkraft: 16 %

Der fruehere Schatten mit 10 px vertikalem Versatz,
30 px Unschaerfe und 34 % Deckkraft gehoert nicht mehr
zum Content-Box-Standard.

### Zukuenftige Theme-Varianten

Die Vorlage gilt fuer das aktuelle topa-LE Dark Theme.

Bei kuenftigen Theme-Varianten, beispielsweise Blue Dark,
duerfen Farben oder Kontraste bewusst angepasst werden.

Solche Aenderungen muessen erneut visuell getestet und
anschliessend zentral in dieser Dokumentation festgehalten
werden.

Keine abweichenden Content-Box-Farben oder Schattenwerte
ohne bewusste Designentscheidung einfuehren.

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
box-shadow: 0 0 8px rgba(0, 0, 0, 0.16) !important;
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

## API-Keys-Seite

DE: Der Inhaltsbereich der API-Keys-Seite verwendet denselben
topa-LE Content-Box-Standard.

EN: The API Keys content area uses the same topa-LE
content box standard.

Verifizierte DOM-Struktur:
- Komponente: `.unapi`
- Ueberschrift: `h2` mit Text `API Keys`
- Inhaltscontainer: `.grid.max-w-\\[1024px\\]`

Die dauerhafte CSS-Regel muss auf die API-Keys-Komponente
begrenzt bleiben. Der Button wird separat nach dem
Primary-Action-Button-Standard gestaltet.

## Projektkonvention

Die Anweisung "topa-LE Content-Box verwenden" bezeichnet
diesen einheitlichen Designstandard.

Breite, Positionierung und CSS-Selektoren werden fuer die
jeweilige Unraid-Seite separat festgelegt.
