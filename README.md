# Arch post install flavour packages

wget -O - https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash

# List system tweaks:

- system Serial permission for user

# List of required installed packages:

- dialog
- base-devel
- git
- openssh
- xed
- curl
- python-pyserial
- jq
- wget

# List of selectable installed packages:

- bwm-ng 
- screen
- neovim 
- filezilla 
- meld 
- vlc 
- git 
- htop 
- jq
- brave-browser
- brave-browser extensions
  * bypass-adblock-detection
  * hls-downloader
  * i-dont-care-about-cookies
  * keepassxc-browser
  * session-buddy
  * the-marvellous-suspender
  * url-tracking-stripper-red
  * video-downloader-plus
  * stream-cleaner
  * youtube-nonstop
- remmina
- codium
- codium marketplace replacement (local config)
- codium extensions installed
  * bungcip.better-toml
  * rust-lang.rust-analyzer
  * jinxdash.prettier-rust
  * kogia-sima.vscode-sailfish
  * ms-python.python
  * ms-python.vscode-pylance
  * ms-vscode.cpptools
  * serayuzgur.crates
  * usernamehw.errorlens
  * vadimcn.vscode-lldb
  * jeff-hykin.better-cpp-syntax
  * aaron-bond.better-comments
  * vsciot-vscode.vscode-arduino
  * kamikillerto.vscode-colorize
  * oderwat.indent-rainbow
  * eamodio.gitlens
  * evgeniypeshkov.syntax-highlighter
- codium extensions uninstalled
  * ms-toolsai.jupyter
  * ms-toolsai.jupyter-keymap
  * ms-toolsai.jupyter-renderers
  * ms-toolsai.vscode-jupyter-cell-tags
  * ms-toolsai.vscode-jupyter-slideshow
- marktext
- dbeaver-ce_latest_amd64
- smartgit-latest
- arduino-cli
- keepassxc
- qownnotes
- virtualbox
- kicad
- freecad
- telegram
- rust
- python 3.6 (AUR install)
- python 3.8 (AUR install)
- qtcreator + qt5 + qt5 lib + cmake
- borgbackup + vorta gui
- spotube

# ~~List installed scripts:~~

- vscodium-json-updater.sh
  
  > Replaced with local user .config custom product.json file

# List installed codium extensions:

- Better TOML Language support
  * bungcip.better-toml
- Rust language support for Visual Studio Code
  * rust-lang.rust-analyzer
- Prettier Rust is a code formatter that autocorrects bad syntax
  * jinxdash.prettier-rust
- Syntax Highlighting for Sailfish Templates in VSCode
  * kogia-sima.vscode-sailfish
- Python extension for Visual Studio Code
  * ms-python.python
  * ~~ms-python.vscode-pylance~~
- C/C++ for Visual Studio Code
  * ms-vscode.cpptools
- Helps Rust developers managing dependencies with Cargo.toml.
  * serayuzgur.crates
- Improve highlighting of errors, warnings and other language diagnostics.
  * usernamehw.errorlens
- CodeLLDB (A native debugger powered by LLDB. Debug C++, Rust and other compiled languages)
  * vadimcn.vscode-lldb
- The bleeding edge of the C++ syntax
  * jeff-hykin.better-cpp-syntax
- Improve your code commenting by annotating with alert, informational, TODOs, and more!
  * aaron-bond.better-comments
- Arduino for Visual Studio Code
  * vsciot-vscode.vscode-arduino
- A vscode extension to help visualize css colors in files.
  * kamikillerto.vscode-colorize
- A simple extension to make indentation more readable
  * oderwat.indent-rainbow
- Git supercharged
  * eamodio.gitlens
- Syntax highlighting based on Tree-sitter
  * evgeniypeshkov.syntax-highlighter

# List installed languagess:

- rust

# Extra:

- install neovim res
- install xed theme
- install gedit theme
- install VLC Media Library
- add user to dialout group
- add bash aliases
