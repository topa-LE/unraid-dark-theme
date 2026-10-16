<div align="center">

# 🎨 topa-LE Unraid Dark Theme

**A modern, customizable dark experience for the Unraid WebGUI.**

[![Unraid](https://img.shields.io/badge/Unraid-7.x-EA4B25?style=for-the-badge&logo=unraid&logoColor=white)](https://unraid.net/)
[![Version](https://img.shields.io/badge/Version-1.0.0-3274A1?style=for-the-badge&logo=github&logoColor=white)](VERSION)
[![CSS3](https://img.shields.io/badge/CSS3-Dark%20Styling-1572B6?style=for-the-badge&logo=css&logoColor=white)](css/)
[![JavaScript](https://img.shields.io/badge/JavaScript-Interactive-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](js/)
[![Bash](https://img.shields.io/badge/Bash-Installer-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](scripts/)
[![Fonts](https://img.shields.io/badge/Fonts-10%20Choices-8957E5?style=for-the-badge&logo=googlefonts&logoColor=white)](#-font-switcher) [![English](https://img.shields.io/badge/🇬🇧-English-3274A1?style=for-the-badge)](README.md) ![Deutsch](https://img.shields.io/badge/🇩🇪-Deutsch-C65A16?style=for-the-badge)

**Dark WebGUI · Custom Login · Font Switcher · Persistent Installation**

[Features](#-features) •
[Font Switcher](#-font-switcher) •
[Installation](#-installation) •
[Updates](#-updating) •
[Rollback](#-uninstall-and-rollback)

</div>

---

## ✨ Features

<table width="100%">
  <thead>
    <tr><th width="30%">Component</th><th width="70%">Description</th></tr>
  </thead>
  <tbody>
    <tr><td>🎨 Dark WebGUI</td><td>Dark grey and blue styling with extensive CSS customization</td></tr>
    <tr><td>🔐 Custom Login</td><td>Themed login screen, custom avatar and repository link</td></tr>
    <tr><td>🔤 Font Switcher</td><td>Ten selectable font options, including the Unraid standard</td></tr>
    <tr><td>💾 Persistent Setup</td><td>Theme files and boot integration stored on the Unraid flash drive</td></tr>
    <tr><td>🌐 Language Fix</td><td>Compatibility fix for the native Unraid language selector</td></tr>
    <tr><td>📊 System Statistics</td><td>Dedicated JavaScript integration for system statistics</td></tr>
    <tr><td>⚙️ Array Operations</td><td>Dedicated JavaScript integration for array-operation UI elements</td></tr>
    <tr><td>🖥️ WebTerminal</td><td>Custom terminal colors, font settings and persistent font size</td></tr>
    <tr><td>🔄 Maintenance</td><td>GitHub-based installation, updating and uninstall support</td></tr>
  </tbody>
</table>

The theme also contains detailed styling for navigation elements, forms,
tables, buttons, dialogs, hover effects and other WebGUI components.

---

## 🔤 Font Switcher

The **Aa** button appears immediately to the left of the native
language selector in the authenticated Unraid WebGUI.

Clicking the button opens a font-selection menu. Selecting a font
applies it immediately without requiring a page reload.

### Available fonts

<table width="100%">
  <thead>
    <tr>
      <th align="center">#</th>
      <th>Font</th>
      <th>Visual character</th>
      <th>Source</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td align="center">01</td>
      <td><strong>Standard (Unraid)</strong></td>
      <td>Original Clear Sans appearance</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">02</td>
      <td><strong>Titillium Web</strong></td>
      <td>Modern, technical and versatile</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">03</td>
      <td><strong>Inter</strong></td>
      <td>Neutral, clean and highly legible</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">04</td>
      <td><strong>Maven Pro</strong></td>
      <td>Contemporary, soft geometric shapes</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">05</td>
      <td><strong>Saira Condensed</strong></td>
      <td>Narrow, bold and distinctive</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">06</td>
      <td><strong>Roboto Condensed</strong></td>
      <td>Compact and functional</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">07</td>
      <td><strong>Ubuntu Condensed</strong></td>
      <td>Narrow with a recognizable character</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">08</td>
      <td><strong>Dosis</strong></td>
      <td>Light, rounded and friendly</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">09</td>
      <td><strong>Cuprum</strong></td>
      <td>Technical and space-efficient</td>
      <td>Local</td>
    </tr>
    <tr>
      <td align="center">10</td>
      <td><strong>Play</strong></td>
      <td>Geometric and structured</td>
      <td>Local</td>
    </tr>
  </tbody>
</table>

All ten font options are defined in
[`js/font-switcher.js`](js/font-switcher.js).

Font assets are included in the [`fonts/`](fonts/) directory
as locally hosted WOFF2 files.

### How font selection works

<table width="100%">
  <thead>
    <tr>
      <th>Setting</th>
      <th>Behavior</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Default theme selection</td>
      <td>Titillium Web</td>
    </tr>
    <tr>
      <td>Native Unraid appearance</td>
      <td>Standard (Unraid)</td>
    </tr>
    <tr>
      <td>Selection method</td>
      <td>Aa dropdown in the top navigation</td>
    </tr>
    <tr>
      <td>Application</td>
      <td>Immediate CSS font-family update</td>
    </tr>
    <tr>
      <td>Persistence</td>
      <td>Browser <code>localStorage</code></td>
    </tr>
    <tr>
      <td>Storage key</td>
      <td><code>topa-font-choice</code></td>
    </tr>
    <tr>
      <td>Scope</td>
      <td>Authenticated WebGUI</td>
    </tr>
    <tr>
      <td>Login and password-reset pages</td>
      <td>Independently styled</td>
    </tr>
  </tbody>
</table>

The switcher uses the CSS custom property
`--topa-font-family` and the `data-topa-font` attribute.

The preference is stored locally in the browser.
It is not a server-wide setting shared between browsers or devices.

### Implementation files

<table width="100%">
  <thead>
    <tr>
      <th>File</th>
      <th>Purpose</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td><a href="js/font-switcher.js"><code>js/font-switcher.js</code></a></td>
      <td>Dropdown, font selection and persistence</td>
    </tr>
    <tr>
      <td><a href="css/font-switcher.css"><code>css/font-switcher.css</code></a></td>
      <td>Font-switcher styling</td>
    </tr>
    <tr>
      <td><a href="css/fonts.css"><code>css/fonts.css</code></a></td>
      <td>Local font definitions</td>
    </tr>
    <tr>
      <td><a href="fonts/"><code>fonts/</code></a></td>
      <td>WOFF2 assets and font license files</td>
    </tr>
  </tbody>
</table>

---

## 🌐 Language Switch Compatibility Fix

The theme includes a compatibility fix for the native Unraid
language selector.

When switching to English, the previously selected language can
be remembered and restored if the Unraid locale cookie is missing.

<table width="100%">
  <thead>
    <tr>
      <th>Feature</th>
      <th>Implementation</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Language identifiers</td>
      <td>Supports identifiers such as <code>de_DE</code></td>
    </tr>
    <tr>
      <td>Persistence</td>
      <td>Browser local storage</td>
    </tr>
    <tr>
      <td>Switching</td>
      <td>Uses Unraid's native mechanism</td>
    </tr>
    <tr>
      <td>Script</td>
      <td><a href="js/language-switch-fix.js"><code>js/language-switch-fix.js</code></a></td>
    </tr>
    <tr>
      <td>Installation</td>
      <td>Integrated into the standard installer</td>
    </tr>
    <tr>
      <td>Verified behavior</td>
      <td>Repeated German-English-German switching on Unraid 7.3.2</td>
    </tr>
  </tbody>
</table>

The implementation does not hardcode German as the only
supported previous language.

---

## 🖼️ Screenshots

### Custom login avatar

<div align="center">

<img src="img/topa-le-avatar-login.png" alt="topa-LE custom login avatar" width="160">

</div>

Additional screenshots of the complete login page, dashboard,
font-selection menu and other themed WebGUI components can be
added as the visual documentation grows.

---

## 📦 Installation

> [!IMPORTANT]
> Run the installer as **root** on your Unraid server.
> Back up your Unraid flash configuration before installation.

### Fresh installation

```bash
curl -fsSL https://raw.githubusercontent.com/topa-LE/unraid-dark-theme/main/scripts/bootstrap.sh | bash
```

The bootstrap downloads the current `main` branch and starts
the project installer.

### Installation language

The installer selects German messages for German locales and
English messages for other locales.

An explicit language can also be selected:

**English**

```bash
curl -fsSL https://raw.githubusercontent.com/topa-LE/unraid-dark-theme/main/scripts/bootstrap.sh | TOPA_LANG=en bash
```

**Deutsch**

```bash
curl -fsSL https://raw.githubusercontent.com/topa-LE/unraid-dark-theme/main/scripts/bootstrap.sh | TOPA_LANG=de bash
```

The language selection affects installer messages, not the
language configured in the Unraid WebGUI.

### Persistent installation

The theme is installed under:

```text
/boot/config/custom-css/topa-LE/
```

The installer adds a dedicated theme block to:

```text
/boot/config/go
```

At boot, the theme is reapplied through:

```bash
bash /boot/config/custom-css/topa-LE/scripts/apply.sh
```

The installation integrates the WebGUI stylesheet, supporting
JavaScript modules, custom login styling and the reboot/shutdown
page theme.

---

## 🔄 Updating

Run the installed updater as root:

```bash
bash /boot/config/custom-css/topa-LE/scripts/update.sh
```

The updater downloads the latest `main` branch and runs the
installer again.

Existing rollback state is retained where applicable.

---

## ↩️ Uninstall and Rollback

Run the uninstaller as root:

```bash
bash /boot/config/custom-css/topa-LE/scripts/uninstall.sh
```

The uninstaller removes the theme's boot and WebGUI hooks,
restores saved original configuration values where applicable,
and removes the managed theme directory.

It includes protection checks for original login and terminal
settings. Later manual changes to certain settings are preserved.

> [!WARNING]
> Complete automatic rollback after every possible installation
> failure is not guaranteed. Keep a backup of your Unraid flash
> configuration.

---

## 🖥️ WebTerminal Customization

The theme includes a custom dark terminal palette and
persistent terminal font settings.

<table width="100%">
  <thead>
    <tr>
      <th>Setting</th>
      <th>Theme configuration</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>Background</td>
      <td>Dark</td>
    </tr>
    <tr>
      <td>Foreground</td>
      <td>Light</td>
    </tr>
    <tr>
      <td>Cursor</td>
      <td>Warm accent</td>
    </tr>
    <tr>
      <td>Font family</td>
      <td>Cascadia Mono, Consolas, monospace</td>
    </tr>
    <tr>
      <td>Font size</td>
      <td>17</td>
    </tr>
    <tr>
      <td>Line height</td>
      <td>1.15</td>
    </tr>
  </tbody>
</table>

The original terminal configuration is retained for restoration
where applicable.

---

## 🧩 Repository Structure

The following tree shows the tracked project structure. Bundled font assets are summarized for readability.

```text
unraid-dark-theme/
├── css/
│   ├── base.css
│   ├── boot.css
│   ├── font-switcher.css
│   ├── fonts.css
│   ├── loader.css
│   ├── overrides.css
│   └── theme.css
├── docs/
│   ├── unraid-content-box.md
│   ├── unraid-popup-box.md
│   └── unraid-status-colors.md
├── fonts/
│   └── …
├── img/
│   └── topa-le-avatar-login.png
├── js/
│   ├── array-operation.js
│   ├── font-switcher.js
│   ├── language-switch-fix.js
│   └── system-stats.js
├── login/
│   └── login-theme.css
├── scripts/
│   ├── lib/
│   │   └── i18n.sh
│   ├── apply.sh
│   ├── bootstrap.sh
│   ├── install.sh
│   ├── uninstall.sh
│   └── update.sh
├── .gitignore
├── LICENSE
├── README.md
└── VERSION
```

### Technical documentation

- [Content boxes](docs/unraid-content-box.md)
- [Popup boxes](docs/unraid-popup-box.md)
- [Status colors](docs/unraid-status-colors.md)

---

## 🛡️ Compatibility

This theme modifies parts of the Unraid WebGUI and its runtime
integration. Unraid updates may change underlying markup or
styles and require compatibility adjustments.

The original project documentation records testing on Unraid
7.2.5, and the language-switch fix was tested on Unraid 7.3.2.

These observations are not a guarantee of compatibility with
every Unraid 7.x release.

---

## 🛠️ Development

Development is tracked through Git. Visual changes and
installer modifications are tested against real Unraid
installations before release.

The project keeps the theme source, installation scripts,
local fonts and supporting documentation in this repository.

---

## 📜 License

The original theme source code and project documentation are released under
the **[MIT License](LICENSE)**.

Copyright © 2026 topa-LE.

The bundled fonts are third-party assets and remain subject to their
respective license and copyright terms. Their license files are retained
in the corresponding subdirectories of [`fonts/`](fonts/).

Made with ❤️ by topa-LE · [⬆ Back to top](#-topa-le-unraid-dark-theme)
