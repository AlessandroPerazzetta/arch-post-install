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
  * ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
  * ["Better TOML: Better TOML Language support"]="bungcip.better-toml"
  * ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
  * ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
  * ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
  * ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
  * ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
  * ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
  * ~~["Arduino: Arduino for Visual Studio Code"]="vsciot-vscode.vscode-arduino"~~
  * ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
  * ["isort: Import organization support for Python files using isort."]="ms-python.isort"
  * ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
  * ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
  * ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
  * ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
  * ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
  * ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
  * ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
  * ["crates: Helps Rust developers managing dependencies with Cargo.toml."]="serayuzgur.crates"
  * ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
  * ["GitLens — Git supercharged: Supercharge Git within VS Code"]="eamodio.gitlens"
  * ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
  * ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
- codium extensions uninstalled
  * ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
  * ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
  * ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
  * ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
  * ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
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
- SSH alive interval (15) and count (1)
- SSH skip check hosts
- borgbackup + vorta gui
- spotube

# ~~List installed scripts:~~

- vscodium-json-updater.sh
  
  > Replaced with local user .config custom product.json file

# List installed languagess:

- rust

# Extra:

- install neovim res
- install xed theme
- install gedit theme
- install VLC Media Library
- add user to dialout group
- add bash aliases
