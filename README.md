# Arch post install flavour packages

## Quick Start

Run with predefined options:
```bash
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash
```

Uncheck all options:
```bash
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash -s -- --none
```

See [ref/instructions.md](ref/instructions.md) for branch-targeted testing with the `ARCH_BRANCH` env var.

## Project Structure

```
install-packages.sh        # thin orchestrator (~220 lines)
lib/
  colors.sh                # color variable definitions + NEWT_COLORS export
  helpers.sh               # command_exists, install_brave_extensions
modules/
  <key>.sh                 # one file per option, exposes install_<key>()
ref/
  instructions.md          # developer notes and testing instructions
```

Each module carries `# DESC:`, `# DEFAULT:`, `# ORDER:`, and (optionally) `# REQUIRE:` metadata headers.
Dropping a new `.sh` file into `modules/` is all that is needed to add it to the checklist menu — no other file needs updating.

## What Gets Installed

### Always — system setup

#### System tweaks

| Tweak | Description |
|---|---|
| Serial permission | Adds current user to `uucp` group (`/dev/ttyUSBx` access) |
| python-pyserial | Python serial library |

#### Required packages

The following are installed unconditionally before the selection dialog:

| Package | Notes |
|---|---|
| `curl` | |
| `wget` | |
| `git` | |
| `jq` | Used for remote module discovery |
| `pigz` | |
| `pbzip2` | |
| `pxz` | |
| `zip` | |
| `unzip` | |
| `openssh` | Binary: `ssh` |
| `ripgrep` | Binary: `rg` |
| `bat` | |
| `net-tools` | Binary: `ifconfig` |
| `inetutils` | Binary: `hostname` |
| `base-devel` | Package group |
| openssh service | Enabled and started via systemctl |
| `yay` | AUR helper — cloned and built from AUR if not present |

### Selectable modules

> **Default** column reflects the pre-selected state when running without `--none`.

#### Desktop

| Module | Default |
|---|---|
| xed | on |
| xed theme resources | on |
| gedit theme resources | off |

#### Terminals

| Module | Default |
|---|---|
| screen | on |
| tmux | on |
| tmux resources | on |
| alacritty | on |
| alacritty resources | on |
| tabby | on |
| kitty | off |
| kitty resources | off |
| kitty libgl fix | off |
| tabby libgl fix | off |

#### Editors & IDEs

| Module | Default |
|---|---|
| vim | on |
| vim resources | on |
| neovim | on |
| vscode | on |
| vscode extensions | on |
| zed_editor (sources install) | on |
| ferrite editor | on |
| vscodium | off |
| vscodium extensions | off |
| marktext | off |

#### Browsers

| Module | Default |
|---|---|
| brave-browser | on |
| brave-browser extensions | on |
| brave-origin-browser | off |
| brave-origin-browser extensions | off |

#### Development tools

| Module | Default |
|---|---|
| grpcurl (AUR install) | on |
| arduino-cli | on |
| rust | on |
| dbeaver | on |
| unison + unison-gtk (AUR install) | on |
| lazygit | off |
| python 3.6 (AUR install) | off |
| python 3.8 (AUR install) | off |
| qtcreator + qt5 | off |

#### System & utilities

| Module | Default |
|---|---|
| personal resources | on |
| system Serial permission | on |
| system utils | on |
| remmina | on |
| ssh-alive-settings | on |
| ssh-skip-hosts-check-settings | on |
| virtualbox | on |
| borgbackup + vorta gui | on |
| keepassxc | on |
| fonts (AUR install) | on |
| yt-dlp (AUR install) | on |
| spotube (AUR install) | off |
| cliamp (AUR install) | off |

#### Messaging & media

| Module | Default |
|---|---|
| telegram | on |
| vlc | on |

#### Other

| Module | Default |
|---|---|
| filezilla | on |
| meld | on |
| MQTT Explorer (AUR install) | on |
| Bruno The Git-native API client (AUR install) | on |
| qownnotes | on |
| kicad | on |
| freecad | on |
| smartgit | off |

### Browser extensions

#### Brave / Brave Origin

- ublock-origin
- bypass-adblock-detection
- hls-downloader
- i-dont-care-about-cookies
- keepassxc-browser
- session-buddy
- the-marvellous-suspender
- url-tracking-stripper-red
- video-downloader-plus
- youtube-nonstop
- user-agent-switcher-for-c
- modheader-modify-http-hea
- enhancer-for-youtube
- disable-twitch-extensions

### VS Code / VSCodium extensions

Both editors share the same extension set. Exceptions are noted below.

| Extension ID | Notes |
|---|---|
| aaron-bond.better-comments | |
| tamasfe.even-better-toml | |
| esbenp.prettier-vscode | |
| evgeniypeshkov.syntax-highlighter | |
| jeff-hykin.better-cpp-syntax | |
| kamikillerto.vscode-colorize | |
| oderwat.indent-rainbow | |
| ms-vscode.vscode-serial-monitor | |
| vscode-arduino.vscode-arduino-community | |
| ms-python.isort | |
| ms-python.pylint | |
| ms-python.python | |
| ms-python.vscode-pylance | |
| vadimcn.vscode-lldb | |
| jinxdash.prettier-rust | |
| rust-lang.rust-analyzer | |
| fill-labs.dependi | |
| shd101wyy.markdown-preview-enhanced | |
| usernamehw.errorlens | |
| Gruntfuggly.todo-tree | |
| ahmadawais.shades-of-purple | |
| cnojima.readable-indent | |
| emmanuelbeziat.vscode-great-icons | |
| DrBlury.protobuf-vsc | |
| Meezilla.json | |
| ms-vscode.cpptools | VS Code: marketplace; VSCodium: `.vsix` (v1.24.5) |
| ms-vscode-remote.remote-ssh | VS Code only |
| jeanp413.open-remote-ssh | VSCodium only (`.vsix` from GitHub releases) |
| GitHub.copilot | VSCodium only (`.vsix` from marketplace) |
| GitHub.copilot-chat | VSCodium only (`.vsix` from marketplace) |

#### Uninstalled by default

- ms-toolsai.jupyter
- ms-toolsai.jupyter-keymap
- ms-toolsai.jupyter-renderers
- ms-toolsai.vscode-jupyter-cell-tags
- ms-toolsai.vscode-jupyter-slideshow

#### Removed / replaced

| Removed | Replaced by |
|---|---|
| bungcip.better-toml | tamasfe.even-better-toml |
| vsciot-vscode.vscode-arduino | vscode-arduino.vscode-arduino-community |
| serayuzgur.crates | fill-labs.dependi |
| zxh404.vscode-proto3 | DrBlury.protobuf-vsc |
| eamodio.gitlens | removed |

## Fonts

Installed by the `fonts` module (AUR):

- `ttf-nerd-fonts-symbols`
- `ttf-jetbrains-mono-nerd`

## Adding a New Module

1. Create `modules/<key>.sh` with the following template:

```bash
#!/usr/bin/env bash
# Module: <key>
# DESC: <human readable description>
# DEFAULT: on|off
# ORDER: <number>
# REQUIRE: <dep-key>   # optional: key of a module that must run first
# Called by install-packages.sh orchestrator

install_<key>() {
    # installation logic here
}
```

2. No other file needs updating — the orchestrator discovers modules automatically from `modules/`.
