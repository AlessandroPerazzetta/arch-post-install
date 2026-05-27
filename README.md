# arch-post-install

Post-install automation for Arch Linux. Runs system tweaks, installs required
tooling, and presents an interactive checklist of optional packages — all from a
single `curl | bash` one-liner.

## Quick Start

```bash
# Run with defaults
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash

# Run with all options pre-deselected
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash -s -- --none
```

## Project Structure

```
install-packages.sh        # thin orchestrator
lib/
  colors.sh                # terminal color variables
  helpers.sh               # shared functions (command_exists, install_brave_extensions)
modules/
  <key>.sh                 # one module per selectable item — auto-discovered at runtime
```

Each module carries its own metadata:

```bash
# DESC: Human readable label shown in the checklist
# DEFAULT: on|off
# ORDER: <number>          # execution priority — lower runs first
# REQUIRE: <dep-key>      # omit if no dependency
```

- `ORDER` controls both the checklist display sequence and the installation sequence. Use multiples of 10 to leave room for future modules.
- `REQUIRE` names a module that must run first. The orchestrator auto-includes it if the user didn't select it.

Dropping a new `.sh` file into `modules/` is all that is needed to add it to the menu.

## What Gets Installed

### Always — system setup

| Item | Description |
|---|---|
| Serial permission | Adds current user to `uucp` group (`/dev/ttyUSBx` access) |
| Required packages | `curl` `wget` `git` `jq` `pigz` `pbzip2` `pxz` `zip` `unzip` `openssh` `ripgrep` `bat` `net-tools` `inetutils` `base-devel` |
| yay | AUR helper — cloned and built from AUR if not present |
| openssh service | Enabled and started via systemctl |

### Selectable modules (interactive checklist)

> **Default** column reflects the pre-selected state when running without `--none`.

#### Desktop

| Module | Default |
|---|---|
| xed + theme resources | on |
| gedit theme resources | off |

#### Terminals

| Module | Default |
|---|---|
| screen | on |
| tmux + resources | on |
| alacritty + resources | on |
| tabby | on |
| kitty + resources | off |
| kitty libgl fix | off |
| tabby libgl fix | off |

#### Editors & IDEs

| Module | Default |
|---|---|
| vim + resources | on |
| neovim | on |
| VS Code + extensions | on |
| Zed editor | on |
| Ferrite editor | on |
| VSCodium + extensions | off |
| marktext | off |

#### Browsers

| Module | Default |
|---|---|
| Brave browser + extensions | on |
| Brave Origin browser + extensions | off |

#### Development tools

| Module | Default |
|---|---|
| grpcurl (AUR) | on |
| arduino-cli | on |
| Rust | on |
| DBeaver | on |
| unison + unison-gtk (AUR) | on |
| lazygit | off |
| Python 3.6 (AUR) | off |
| Python 3.8 (AUR) | off |
| qtcreator + Qt5 | off |

#### System & utilities

| Module | Default |
|---|---|
| personal resources | on |
| system serial permission | on |
| system utils | on |
| remmina | on |
| SSH alive settings | on |
| SSH skip hosts check | on |
| VirtualBox | on |
| borgbackup + Vorta GUI | on |
| KeePassXC | on |
| fonts (AUR) | on |
| yt-dlp (AUR) | on |
| spotube (AUR) | off |
| cliamp (AUR) | off |

#### Messaging & media

| Module | Default |
|---|---|
| Telegram | on |
| VLC | on |

#### Other

| Module | Default |
|---|---|
| FileZilla | on |
| meld | on |
| MQTT Explorer (AUR) | on |
| Bruno (AUR) | on |
| QOwnNotes | on |
| KiCad | on |
| FreeCAD | on |
| SmartGit | off |

### Browser extensions

#### Brave / Brave Origin
- ublock-origin, bypass-adblock-detection, hls-downloader
- i-dont-care-about-cookies, keepassxc-browser
- session-buddy, the-marvellous-suspender
- url-tracking-stripper-red, video-downloader-plus
- youtube-nonstop, user-agent-switcher-for-c
- modheader-modify-http-hea, enhancer-for-youtube, disable-twitch-extensions

### VS Code / VSCodium extensions

Both editors install the same extension set. Exceptions are noted.

**Installed:**
- Better Comments, Even Better TOML, Prettier
- Syntax Highlighter, Better C++ Syntax
- colorize, indent-rainbow, Readable Indent, VSCode Great Icons
- Serial Monitor
- Arduino Community Edition
- isort, Pylint, Python, Pylance, CodeLLDB
- Prettier (Rust), rust-analyzer, Dependi
- Markdown Preview Enhanced
- Error Lens, Todo Tree
- Shades of Purple
- Protobuf VSC, JSON Beautify
- C/C++
- Remote - SSH *(VS Code only)*
- Open Remote SSH *(VSCodium only — `.vsix` from GitHub releases)*
- GitHub Copilot + Copilot Chat *(VSCodium only — `.vsix` from marketplace)*

**Removed / replaced:**

| Removed | Replacement |
|---|---|
| Better TOML | Even Better TOML |
| vscode-arduino | Arduino Community Edition |
| crates | Dependi |
| vscode-proto3 | Protobuf VSC |
| GitLens | — |
| Jupyter suite (5 extensions) | — |

## Fonts

Installed by the `fonts` module (AUR):
- FiraCode Nerd Font (`ttf-nerd-fonts-symbols`)
- JetBrains Mono Nerd Font (`ttf-jetbrains-mono-nerd`)

## Adding a New Module

1. Create `modules/<key>.sh`:

```bash
#!/usr/bin/env bash
# Module: <key>
# DESC: Description shown in the checklist
# DEFAULT: on|off
# ORDER: <number>
# REQUIRE: <dep-key>   # optional: key of a module that must run first
# Called by install-packages.sh orchestrator

install_<key>() {
    # installation logic here
}
```

2. The module is auto-discovered — no changes to any other file are needed.
