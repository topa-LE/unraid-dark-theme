# topa-LE First Gold-Orange Button

## Verbindlicher Designstandard – FINAL

Status: Visuell freigegeben am 18.10.2026.

Der First Gold-Orange Button ist der hervorgehobene
Primary Action Button im topa-LE Unraid Dark Theme.

Er kennzeichnet wichtige Hauptaktionen, die sich
deutlich von normalen Bedien- und Navigationsbuttons
unterscheiden sollen.

## Originalreferenz

Unraid 7.3.3, Update-Seite:

"Downgrade auf 7.3.2 beginnen"

Die CSS-Werte wurden am 18.10.2026 direkt mit
Chrome DevTools aus dem Originalelement ermittelt.

Der Originalbutton verwendet ein transparentes
span-Element mit role="button".

Der sichtbare Farbverlauf befindet sich in einem
inneren div-Element.

Originalklassen des Verlaufselements:

    from-unraid-red
    to-orange
    bg-linear-to-r

## Verbindliche Farben

Startfarbe:

    RGB: 226, 40, 40
    HEX: #E22828

Endfarbe:

    RGB: 243, 187, 142
    HEX: #F3BB8E

Schriftfarbe:

    #FFFFFF

## Verbindlicher Farbverlauf

    background: linear-gradient(
        to right in oklab,
        #E22828 0%,
        #F3BB8E 100%
    ) !important;

Die Interpolation in oklab ist Bestandteil
des Originaldesigns.

Nicht durch einen einfarbigen Orange- oder
Goldton ersetzen.

## Weitere Eigenschaften

    color: #FFFFFF !important;
    border-color: transparent !important;
    border-radius: 7.5px !important;
    box-shadow: none !important;
    font-weight: 600;

Der Originalbutton besitzt 12 px Innenabstand.

Abmessungen und Innenabstaende koennen je nach
Position und vorhandener Unraid-Komponente variieren.

## Hover-Verhalten

Der Originalverlauf verwendet bei Hover
eine Deckkraft von 60 Prozent.

Original:

    group-hover:!opacity-60

Bei direkter Gestaltung des Buttons kann
folgende Regel verwendet werden:

    opacity: 0.6 !important;

Wichtig:

Die Deckkraft wirkt beim direkten Button-Selektor
auch auf die Schrift und das Icon.

Das Original verwendet die reduzierte Deckkraft
nur auf dem inneren Verlaufselement.

Bei einer kuenftigen gemeinsamen CSS-Komponente
soll diese Unterscheidung beruecksichtigt werden.

## Verwendungszweck

Geeignet fuer wichtige Hauptaktionen, beispielsweise:

- Update- und Downgrade-Aktionen
- Create API Key
- Wichtige Bestaetigungs- und Startaktionen
- Vergleichbare Primary Actions in Unraid-Plugins

Nicht pauschal auf alle Buttons anwenden.

Normale Navigation, sekundaere Aktionen und
Statusmeldungen behalten ihre eigenen Farben.

## Bereits getestete Seiten

### Unraid Update

Originalreferenz des Farbverlaufs.

### API Keys

Live-Test am 18.10.2026 erfolgreich.

Verifizierter Button:

    span[role="button"]

Text:

    Create API Key

Der Test verwendete den Originalverlauf direkt
auf dem Button-Element.

## Gestaltungsregeln

1. Die dokumentierten Farben exakt uebernehmen.
2. Den oklab-Farbverlauf beibehalten.
3. Keine geschaetzten Gold-Orange-Farbwerte verwenden.
4. CSS-Selektoren vor der Uebernahme im Browser pruefen.
5. Nur gezielt ausgewaehlte Hauptaktionen gestalten.
6. Bestehende Unraid-Funktionen unveraendert lassen.
7. Neue Varianten zuerst in Chrome DevTools testen.
8. Nach Freigabe in css/overrides.css uebernehmen.
9. Deployment ueber GitHub und den Theme-Updater.

## Zukuenftige Theme-Varianten

Der Standard gilt fuer das aktuelle
topa-LE Unraid Dark Theme.

Bei kuenftigen Theme-Varianten wie Blue Dark
kann eine bewusste Anpassung erfolgen.

Aenderungen muessen visuell getestet und
anschliessend zentral dokumentiert werden.

## Projektkonvention

Die Anweisung "First Gold-Orange Button verwenden"
bezeichnet diesen verbindlichen Designstandard.

Farbwerte und Verlauf werden nicht bei jeder
neuen Seite erneut festgelegt.
