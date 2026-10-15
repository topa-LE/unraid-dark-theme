<div align="center">

# 🎨 topa-LE Unraid Dark Theme

**A modern, customizable dark experience for the Unraid WebGUI.**

[![Unraid](https://img.shields.io/badge/Unraid-7.x-EA4B25?style=for-the-badge&logo=unraid&logoColor=white)](https://unraid.net/)
[![Version](https://img.shields.io/badge/Version-1.0.0-3274A1?style=for-the-badge&logo=github&logoColor=white)](VERSION)
[![CSS3](https://img.shields.io/badge/CSS3-Dark%20Styling-1572B6?style=for-the-badge&logo=css&logoColor=white)](css/)
[![JavaScript](https://img.shields.io/badge/JavaScript-Interactive-F7DF1E?style=for-the-badge&logo=javascript&logoColor=black)](js/)
[![Bash](https://img.shields.io/badge/Bash-Installer-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](scripts/)
[![Fonts](https://img.shields.io/badge/Fonts-10%20Choices-8957E5?style=for-the-badge&logo=googlefonts&logoColor=white)](#-font-switcher) [![English](https://img.shields.io/badge/🇬🇧-English-3274A1?style=for-the-badge)](README.md) ![Deutsch](https://img.shields.io/badge/🇩🇪-Deutsch-555555?style=for-the-badge)

**Dark WebGUI · Custom Login · Font Switcher · Persistent Installation**

[Features](#-features) •
[Font Switcher](#-font-switcher) •
[Installation](#-installation) •
[Updates](#-updating) •
[Rollback](#-uninstall-and-rollback)

</div>

---

## ✨ Features

| Component | Description |
|:--|:--|
| 🎨 Dark WebGUI | Dark grey and blue styling with extensive CSS customization |
| 🔐 Custom Login | Themed login screen, custom avatar and repository link |
| 🔤 Font Switcher | Ten selectable font options, including the Unraid standard |
| 💾 Persistent Setup | Theme files and boot integration stored on the Unraid flash drive |
| 🌐 Language Fix | Compatibility fix for the native Unraid language selector |
| 📊 System Statistics | Dedicated JavaScript integration for system statistics |
| ⚙️ Array Operations | Dedicated JavaScript integration for array-operation UI elements |
| 🖥️ WebTerminal | Custom terminal colors, font settings and persistent font size |
| 🔄 Maintenance | GitHub-based installation, updating and uninstall support |

The theme also contains detailed styling for navigation elements, forms,
tables, buttons, dialogs, hover effects and other WebGUI components.

---

## 🔤 Font Switcher

The **Aa** button appears immediately to the left of the native
language selector in the authenticated Unraid WebGUI.

Clicking the button opens a font-selection menu. Selecting a font
applies it immediately without requiring a page reload.

### Available fonts

| # | Font | Visual character | Source |
|:--:|:--|:--|:--|
| 01 | **Standard (Unraid)** | Original Clear Sans appearance | Local |
| 02 | **Titillium Web** | Modern, technical and versatile | Local |
| 03 | **Inter** | Neutral, clean and highly legible | Local |
| 04 | **Maven Pro** | Contemporary, soft geometric shapes | Local |
| 05 | **Saira Condensed** | Narrow, bold and distinctive | Local |
| 06 | **Roboto Condensed** | Compact and functional | Local |
| 07 | **Ubuntu Condensed** | Narrow with a recognizable character | Local |
| 08 | **Dosis** | Light, rounded and friendly | Local |
| 09 | **Cuprum** | Technical and space-efficient | Local |
| 10 | **Play** | Geometric and structured | Local |

All ten font options are defined in
[`js/font-switcher.js`](js/font-switcher.js).

Font assets are included in the [`fonts/`](fonts/) directory
as locally hosted WOFF2 files.

### How font selection works

| Setting | Behavior |
|:--|:--|
| Default theme selection | Titillium Web |
| Native Unraid appearance | Standard (Unraid) |
| Selection method | Aa dropdown in the top navigation |
| Application | Immediate CSS font-family update |
| Persistence | Browser `localStorage` |
| Storage key | `topa-font-choice` |
| Scope | Authenticated WebGUI |
| Login and password-reset pages | Independently styled |

The switcher uses the CSS custom property
`--topa-font-family` and the `data-topa-font` attribute.

The preference is stored locally in the browser.
It is not a server-wide setting shared between browsers or devices.

### Implementation files

| File | Purpose |
|:--|:--|
| [`js/font-switcher.js`](js/font-switcher.js) | Dropdown, font selection and persistence |
| [`css/font-switcher.css`](css/font-switcher.css) | Font-switcher styling |
| [`css/fonts.css`](css/fonts.css) | Local font definitions |
| [`fonts/`](fonts/) | WOFF2 assets and font license files |

---

## 🌐 Language Switch Compatibility Fix

The theme includes a compatibility fix for the native Unraid
language selector.

When switching to English, the previously selected language can
be remembered and restored if the Unraid locale cookie is missing.

| Feature | Implementation |
|:--|:--|
| Language identifiers | Supports identifiers such as `de_DE` |
| Persistence | Browser local storage |
| Switching | Uses Unraid's native mechanism |
| Script | [`js/language-switch-fix.js`](js/language-switch-fix.js) |
| Installation | Integrated into the standard installer |
| Verified behavior | Repeated German-English-German switching on Unraid 7.3.2 |

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

| Setting | Theme configuration |
|:--|:--|
| Background | Dark |
| Foreground | Light |
| Cursor | Warm accent |
| Font family | Cascadia Mono, Consolas, monospace |
| Font size | 17 |
| Line height | 1.15 |

The original terminal configuration is retained for restoration
where applicable.

---

## 🧩 Repository Structure

| Directory / File | Purpose |
|:--|:--|
| [`css/`](css/) | WebGUI stylesheets and visual overrides |
| [`js/`](js/) | Interactive enhancements and compatibility fixes |
| [`fonts/`](fonts/) | Local font files and license information |
| [`img/`](img/) | Theme images and login avatar |
| [`login/`](login/) | Login-page stylesheet |
| [`scripts/`](scripts/) | Bootstrap, install, apply, update and uninstall |
| [`scripts/lib/`](scripts/lib/) | Shared installer language support |
| [`docs/`](docs/) | Additional technical documentation |
| [`reference/`](reference/) | Project reference materials |
| [`VERSION`](VERSION) | Current project version |

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

## 👤 Author

Created and maintained by **[topa-LE](https://github.com/topa-LE)**.

<div align="center">

---

**Made for a cleaner, darker and more customizable Unraid experience.**

[⬆ Back to top](#-topa-le-unraid-dark-theme)

</div>
