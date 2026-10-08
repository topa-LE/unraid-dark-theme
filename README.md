# Unraid Dark Theme

A modern dark theme for the Unraid WebGUI with a customized login page, dark grey and blue styling, and persistent installation support.

## Features

- Modern dark styling for the Unraid WebGUI
- Dark grey and blue color scheme
- Customized Unraid login page
- Custom login avatar
- Titillium Web typography
- Extensive WebGUI styling and overrides
- Persistent theme loading across reboots
- GitHub-based installation and update workflow
- Clean uninstall and rollback support

## Screenshots

Screenshots of the customized WebGUI and login page will be added as the project documentation grows.

## Compatibility

Currently tested on:

- Unraid 7.2.5

Additional Unraid versions will be tested before being listed as supported.

## Installation

Run the following command as root on your Unraid server:

```bash
curl -fsSL https://raw.githubusercontent.com/topa-LE/unraid-dark-theme/main/scripts/bootstrap.sh | bash
```

The installer downloads the latest version from GitHub and installs the theme under:

```text
/boot/config/custom-css/topa-LE/
```

The theme is automatically applied after reboot through a dedicated entry in /boot/config/go.

The WebTerminal theme uses a persistent font size of **17**.

Original configuration values needed for rollback are stored in the theme's state directory.

## Updating

To update an existing installation, run as root:

```bash
bash /boot/config/custom-css/topa-LE/scripts/update.sh
```

The updater downloads the latest repository version and reapplies the theme while retaining existing rollback state.

## Uninstall and rollback

To uninstall the theme, run as root:

```bash
bash /boot/config/custom-css/topa-LE/scripts/uninstall.sh
```

The uninstaller removes theme hooks and restores saved Unraid settings where applicable.

If the WebTerminal font size was manually changed after installation, that later change is preserved.

**Note:** Back up your Unraid flash configuration before installation. Complete automatic rollback after every possible installation failure is not guaranteed.

## Repository structure

- css - WebGUI theme files
- img - Theme and login images
- login - Login page customization
- scripts - Installation, update and uninstall scripts
- VERSION - Current theme version
- README.md - Project documentation

## Development

The theme is developed and tested against real Unraid installations.

Changes are tracked with Git so visual improvements, compatibility fixes and installer changes can be tested and released in a controlled way.

## Author

Created and maintained by topa-LE.
