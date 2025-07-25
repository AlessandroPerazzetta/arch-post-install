# Arch post install flavour packages

Run with predefined options:
```bash
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash
```
Uncheck all options:
```bash
curl -s https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/main/install-packages.sh | bash -s -- --none
```

# List of required installed packages:
- dialog/whiptail

# List system tweaks:
- system Serial permission for user
- python-pyserial

# List of force installed packages:
- base-devel
- git
- openssh
- curl
- jq
- wget

# List of selectable installed packages:
- screen
- tmux
- tmux resources
- kitty
- kitty resources
- vim
- vim resources
- neovim
- neovim resources
- filezilla
- meld
- vlc
- git
- htop
- brave-browser
- brave-browser extensions
  * ublock-origin
  * bypass-adblock-detection
  * hls-downloader
  * i-dont-care-about-cookies
  * keepassxc-browser
  * session-buddy
  * the-marvellous-suspender
  * url-tracking-stripper-red
  * video-downloader-plus
  * youtube-nonstop
  * user-agent-switcher-for-c
  * modheader-modify-http-hea
  * enhancer-for-youtube
- brave-browser extensions removed
  * ~~stream-cleaner~~
- remmina
- codium
- codium marketplace replacement (local config)
- codium marketplace replacement (env variables)
- codium extensions installed
  * {MARKET} ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
  * ~~{MARKET} ["Better TOML: Better TOML Language support"]="bungcip.better-toml"~~
  * {MARKET} ["Even Better TOML: Fully-featured TOML support"]="tamasfe.even-better-toml"
  * {MARKET} ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
  * {MARKET} ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
  * {MARKET} ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
  * {MARKET} ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
  * {MARKET} ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
  * {MARKET} ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
  * ~~{MARKET} ["Arduino: Arduino for Visual Studio Code"]="vsciot-vscode.vscode-arduino"~~
  * {MARKET} ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
  * {MARKET} ["isort: Import organization support for Python files using isort."]="ms-python.isort"
  * {MARKET} ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
  * {MARKET} ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
  * {MARKET} ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
  * {MARKET} ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
  * {MARKET} ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
  * {MARKET} ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
  * {MARKET} ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
  * {MARKET} ["Dependi: Empowers developers to efficiently manage dependencies and address vulnerabilities in Rust, Go, JavaScript, Typescript, PHP and Python projects."]="fill-labs.dependi"
  * ~~{MARKET} ["crates: Helps Rust developers managing dependencies with Cargo.toml."]="serayuzgur.crates"~~
  * {MARKET} ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
  * ~~{MARKET} ["GitLens — Git supercharged: Supercharge Git within VS Code"]="eamodio.gitlens"~~
  * {MARKET} ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
  * {MARKET} ["Todo Tree: Show TODO, FIXME, etc. comment tags in a tree view"]="Gruntfuggly.todo-tree"
  * {MARKET} ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
  * {GITHUB} ["SSH Host Requirements"]="https://github.com/jeanp413/open-remote-ssh"
- codium extensions uninstalled
  * ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
  * ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
  * ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
  * ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
  * ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
- codium extensions replaced/removed
  * REP>["Arduino: Arduino for Visual Studio Code"]="vsciot-vscode.vscode-arduino"
  * REP>["Better TOML: Better TOML Language support"]="bungcip.better-toml"
  * REM>["GitLens — Git supercharged: Supercharge Git within VS Code"]="eamodio.gitlens"
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
- install tmux res
- install VLC Media Library
- add user to dialout group
- add bash aliases
