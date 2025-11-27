#!/bin/bash
CURRENT_USER=$(whoami)

# Colors definition
BLACK='\033[0;30m'
DGRAY='\033[1;30m'
RED='\033[0;31m'
LRED='\033[1;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
ORANGE='\033[0;33m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
LPURPLE='\033[1;35m'     
CYAN='\033[0;36m'
LCYAN='\033[1;36m'
LGRAY='\033[0;37m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

export NEWT_COLORS='
    root=green,black
    border=green,black
    title=green,black
    roottext=white,black
    window=green,black
    textbox=white,black
    button=black,green
    compactbutton=white,black
    listbox=white,black
    actlistbox=black,white
    actsellistbox=black,green
    checkbox=green,black
    actcheckbox=black,green
'

printf "${YELLOW}------------------------------------------------------------------\n${NC}"
printf "${YELLOW}Starting ...\n${NC}"
printf "${YELLOW}------------------------------------------------------------------\n${NC}"

if [ "$EUID" -eq 0 ]; then
    printf "${LRED}Do not run this script as root. Please run as a regular user.${NC}\n"
    exit 1
fi

printf "${YELLOW}Updating system...\n${NC}"
sleep 1
sudo pacman -Sy

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1

# Function to check if a command exists
command_exists() {
    command -v $1 >/dev/null 2>&1
}

printf "${YELLOW}Updating system...\n${NC}"
sleep 1
sudo pacman -Syyu --noconfirm

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1

commands_to_check_exist=("curl" "wget" "git" "jq" "pigz" "pbzip2" "pxz" "zip" "unzip" "openssh" "ripgrep" "bat" "net-tools" "inetutils")
for cmd in "${commands_to_check_exist[@]}"; do
    # if ! command_exists $cmd; then
    if ! command_exists $cmd; then
        printf "${LCYAN}Command ${cmd} not found. Installing... \n${NC}"
        sudo pacman -Sy $cmd --noconfirm
        printf "\n${NC}"       
    else
        printf "${LGREEN}Command ${cmd} is already installed.\n${NC}"
    fi
done

# Install base-devel if not already installed
if ! pacman -Qi base-devel &>/dev/null; then
    printf "${YELLOW}Installing base-devel...\n${NC}"
    sudo pacman -Sy --needed base-devel --noconfirm
else
    printf "${LGREEN}base-devel is already installed.\n${NC}"
fi

if command -v sshd &> /dev/null; then
    printf "${YELLOW}Openssh found. Checking systemd service...\n${NC}"
    if ! systemctl is-enabled --quiet sshd; then
        printf "${YELLOW}Enabling and starting sshd service...\n${NC}"
        sudo systemctl enable sshd
        sudo systemctl start sshd
    else
        printf "${LGREEN}sshd service is already enabled.\n${NC}"
    fi
fi

if ! command -v yay &> /dev/null
then
    # printf "${YELLOW}Install AUR packages...\n${NC}"
    # sleep 1
    # git clone https://aur.archlinux.org/yay-bin.git
    # cd yay-bin
    # makepkg -si
    # yay -Syu

    printf "${YELLOW}Install yay git package from AUR...\n${NC}"
    cd /tmp/
    if [ -d yay ]; then
        printf "${YELLOW}yay directory already exists, delete before git clone...\n${NC}"
        rm -rf yay
    fi
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && yay -Syu
    cd -
fi

sleep 1

read dialog <<< "$(which whiptail dialog 2> /dev/null)"
[[ "$dialog" ]] || {
    printf "${LRED}Neither whiptail nor dialog found\n${NC}"
    printf "${YELLOW}Consider installing whiptail with:\n${NC}"
    printf "${ORANGE}pacman -S libnewt\n${NC}"
    exit 1
}

# Define all options and their default status in an array of "key|desc|default"
ALL_OPTIONS=(
    "personal_res|personal resources|on"
    "sys_serial|system Serial permission|on"
    "xed|xed|on"
    "xed_res|xed theme resources|on"
    "gedit_res|gedit theme resources|off"
    "sys_utils|system utils|on"
    "kitty|kitty|on"
    "kitty_res|kitty resources|on"
    "kitty_libgl_fix|kitty libgl fix|off"
    "alacritty|alacritty|off"
    "screen|screen|on"
    "tmux|tmux|on"
    "tmux_res|tmux resources|on"
    "vim|vim|on"
    "vim_res|vim resources|on"
    "neovim|neovim|on"
    "filezilla|filezilla|on"
    "meld|meld|on"
    "vlc|vlc|on"
    "brave|brave-browser|on"
    "brave_ext|brave-browser extensions|on"
    "remmina|remmina|on"
    "tabby|tabby|on"
    "tabby_libgl_fix|tabby libgl fix|off"
    "vscodium|vscodium|of"
    "vscodium_ext|vscodium extensions|off"
    "vscode|vscode|on"
    "vscode_ext|vscode extensions|on"
    "zed_editor|zed_editor (sources install)|on"
    "grpcurl|grpcurl (AUR install)|on"
    "unison|unison + unison-gtk (AUR install)|on"
    "marktext|marktext|on"
    "dbeaver|dbeaver|on"
    "smartgit|smartgit|off"
    "arduino_cli|arduino-cli|on"
    "keepassxc|keepassxc|on"
    "qownnotes|qownnotes|on"
    "virtualbox|virtualbox|on"
    "kicad|kicad|on"
    "freecad|freecad|on"
    "telegram|telegram|on"
    "rust|rust|on"
    "py_36|python 3.6 (AUR install)|off"
    "py_38|python 3.8 (AUR install)|off"
    "qt_stuff|qtcreator + qt5|off"
    "ssh_alive|ssh-alive-settings|on"
    "ssh_skip_hosts_check|ssh-skip-hosts-check-settings|on"
    "borgbackup_vorta|borgbackup + vorta gui|on"
    "spotube|spotube (AUR install)|off"
    "fonts|fonts (AUR install)|on"
)

# Parse arguments
ALL_OFF=false
for arg in "$@"; do
    [[ "$arg" == "--none" ]] && ALL_OFF=true
done

# Build options array for dialog/whiptail
options=()
for opt in "${ALL_OPTIONS[@]}"; do
    IFS='|' read -r key desc def <<< "$opt"
    if $ALL_OFF; then
        options+=("$key" "$desc" "off")
    else
        options+=("$key" "$desc" "$def")
    fi
done

cmd=("$dialog" --title "Automated packages installation" --backtitle "Arch Post Install" --separate-output --checklist "Select options:" 22 76 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]
then



    for choice in $choices
    do
        case $choice in
            personal_res)
                printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
                printf "${YELLOW}Installing aliase resources...\n${NC}"
                printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bashrc-personal
                ;;
            sys_serial)
                printf "${YELLOW}Installing python pyserial...\n${NC}"
                pacman -S python-pyserial                
                printf "${YELLOW}Installing system permissions to allow user open Serial...\n${NC}"
                grep -Ei "^uucp" /etc/group;
                if [ $? -eq 0 ]; then
                    printf "${YELLOW}uucp Group Exists add current user...\n${NC}"
                    if id -nG "$CURRENT_USER" | grep -qw "uucp"; then
                        printf "${YELLOW}User is already in uucp group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
                    else
                        printf "${YELLOW}Add user to uucp group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
                        sudo usermod -a -G uucp $CURRENT_USER
                    fi
                else
                    printf "${RED}uucp Group Not Exists can't add current user...\n${NC}"
                fi
                ;;
            xed)
                printf "${YELLOW}Installing xed...\n${NC}"
                sudo pacman -Sy xed --noconfirm
                ;;
            xed_res)
                printf "${YELLOW}Installing Xed resources...\n${NC}"
                mkdir -p ~/.local/share/xed/styles/
                curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            gedit_res)
                printf "${YELLOW}Installing Gedit resources...\n${NC}"
                mkdir -p ~/.local/share/gedit/styles/
                curl -fsSLo ~/.local/share/gedit/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            sys_utils)
                printf "${YELLOW}Installing system utils...\n${NC}"
                sudo pacman -Sy bwm-ng htop --noconfirm
                ;;
            kitty)
                printf "${YELLOW}Installing kitty terminal...\n${NC}"
                sudo pacman -Sy kitty --noconfirm
                ;;
            kitty_res)
                printf "${YELLOW}Installing kitty resources...\n${NC}"
                printf "${YELLOW}Installing kitty resources from git sparse checkout...\n${NC}"
                mkdir -p /tmp/dotfiles-kitty.git
                cd /tmp/dotfiles-kitty.git
                git init
                git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
                git sparse-checkout set kitty
                git pull origin main
                mv kitty ~/.config/
                cd -
                rm -rf /tmp/dotfiles-kitty.git
                ;;
            kitty_libgl_fix)
                # printf "${YELLOW}Installing kitty libgl fix to allow kitty on OPENGL < 2/3 on /etc/profile.d/kitty.sh...\n${NC}"
                # sudo bash -c "echo -e 'export LIBGL_ALWAYS_SOFTWARE=1' > /etc/profile.d/kitty.sh"
                # sudo chmod +x /etc/profile.d/kitty.sh

                TARGET_FILE="/usr/bin/kitty-terminal"
                printf "${YELLOW}Installing kitty-terminal with libgl fix to allow kitty on OPENGL < 2/3 on $TARGET_FILE...\n${NC}"
                # Use sudo and tee to write lines to the file
                echo -e '#!/usr/bin/env bash\nLIBGL_ALWAYS_SOFTWARE=1 kitty'       | sudo tee "$TARGET_FILE" > /dev/null
                # Make the file executable
                sudo chmod +x "$TARGET_FILE"
                ;;
            alacritty)
                printf "${YELLOW}Installing alacritty terminal...\n${NC}"
                sudo pacman -Sy alacritty --noconfirm
                ;;
            screen)
                printf "${YELLOW}Installing screen...\n${NC}"
                sudo pacman -Sy screen --noconfirm
                ;;
            tmux)
                printf "${YELLOW}Installing tmux...\n${NC}"
                sudo pacman -Sy tmux --noconfirm
                ;;
            tmux_res)
                printf "${YELLOW}Installing tmux resources...\n${NC}"
                # curl -fsSLo ~/.tmux.conf https://raw.githubusercontent.com/AlessandroPerazzetta/dotfiles/main/.tmux.conf
                printf "${YELLOW}Installing tmux resources from git sparse checkout...\n${NC}"
                mkdir -p /tmp/dotfiles-tmux.git
                cd /tmp/dotfiles-tmux.git
                git init
                git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
                git sparse-checkout set tmux
                git pull origin main
                mv tmux ~/.config/
                cd -
                rm -rf /tmp/dotfiles-tmux.git
                ;;
            vim)
                printf "${YELLOW}Installing vim...\n${NC}"
                sudo pacman -Sy vim --noconfirm
                ;;
            vim_res)
                printf "${YELLOW}Installing vim resources...\n${NC}"
                printf "${YELLOW}Installing vim resources from git sparse checkout...\n${NC}"
                mkdir -p /tmp/dotfiles-vim.git
                cd /tmp/dotfiles-vim.git
                git init
                git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
                git sparse-checkout set vim
                git pull origin main
                mv vim/vimrc ~/
                cd -
                rm -rf /tmp/dotfiles-vim.git
                ;;
            neovim)
                printf "${YELLOW}Installing neovim...\n${NC}"
                sudo pacman -Sy neovim --noconfirm
                printf "${YELLOW}Installing neovim resources...\n${NC}"
                mkdir -p ~/.config/nvim/
                curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim
                printf "${YELLOW}Set nvim as default editor...\n${NC}"
                sudo sed -i -e "s/EDITOR=nano/EDITOR=vi/g" /etc/environment
                printf "${YELLOW}Create vi nvim symbolic link...\n${NC}"
                sudo ln -s /usr/bin/nvim /usr/local/sbin/vi
                ;;
            filezilla)
                printf "${YELLOW}Installing filezilla...\n${NC}"
                sudo pacman -Sy filezilla --noconfirm
                ;;
            meld)
                printf "${YELLOW}Installing meld...\n${NC}"
                sudo pacman -Sy meld --noconfirm
                ;;
            lazygit)
                printf "${YELLOW}Installing lazygit...\n${NC}"
                sudo pacman -Sy lazygit --noconfirm
                ;;
            vlc)
                printf "${YELLOW}Installing vlc...\n${NC}"
                sudo pacman -Sy vlc --noconfirm
                
                printf "${YELLOW}Installing vlc media library...\n${NC}"
                mkdir -p ~/.local/share/vlc/
                curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
                ;;
            brave)
                printf "${YELLOW}Installing brave-browser...\n${NC}"
                yay -S brave-bin --noconfirm
                ;;
            brave_ext)
                printf "${YELLOW}Installing brave-browser extensions...\n${NC}"
                BRAVE_PATH="/opt/brave-bin"
                BRAVE_EXTENSIONS_PATH="$BRAVE_PATH/extensions"
                if [ -d "$BRAVE_PATH" ]
                then
                    sudo mkdir -p ${BRAVE_EXTENSIONS_PATH}
                    declare -A EXTlist=(
                        ["ublock-origin"]="cjpalhdlnbpafiamejdnhcphjbkeiagm"
                        ["bypass-adblock-detection"]="lppagnomjcaohgkfljlebenbmbdmbkdj"
                        ["hls-downloader"]="hkbifmjmkohpemgdkknlbgmnpocooogp"
                        ["i-dont-care-about-cookies"]="fihnjjcciajhdojfnbdddfaoknhalnja"
                        ["keepassxc-browser"]="oboonakemofpalcgghocfoadofidjkkk"
                        ["session-buddy"]="edacconmaakjimmfgnblocblbcdcpbko"
                        ["the-marvellous-suspender"]="noogafoofpebimajpfpamcfhoaifemoa"
                        ["url-tracking-stripper-red"]="flnagcobkfofedknnnmofijmmkbgfamf"
                        ["video-downloader-plus"]="njgehaondchbmjmajphnhlojfnbfokng"
                        ["youtube-nonstop"]="nlkaejimjacpillmajjnopmpbkbnocid"
                        ["user-agent-switcher-for-c"]="djflhoibgkdhkhhcedjiklpkjnoahfmg"
                        ["modheader-modify-http-hea"]="idgpnmonknjnojddfkpgkljpfnnfcklj"
                        ["enhancer-for-youtube"]="ponfpcnoihfmfllpaingbgckeeldkhle"
                    )
                    for i in "${!EXTlist[@]}"; do
                        # echo "Key: $i value: ${EXTlist[$i]}"
                        # echo '{"external_update_url": "https://clients2.google.com/service/update2/crx"}' > /opt/google/chrome/extensions/${EXTlist[$i]}.json
                        sudo bash -c "echo -e '{ \"external_update_url\": \"https://clients2.google.com/service/update2/crx\" }' > ${BRAVE_EXTENSIONS_PATH}/${EXTlist[$i]}.json"
                    done
                else
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                    printf "ERROR Brave path not found, extensions not installed !!!\n"
                    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                    read -n 1 -s -r -p "Press any key to continue"
                    printf "\n${NC}"
                fi
                ;;
            remmina)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo pacman -Sy remmina --noconfirm
                ;;
            tabby)
                printf "${YELLOW}Installing tabby...\n${NC}"
                sudo pacman -Sy tabby-terminal --noconfirm
                ;;
            tabby_libgl_fix)
                TARGET_FILE="/usr/bin/tabby-terminal"
                printf "${YELLOW}Installing tabby-terminal with libgl fix to allow tabby on OPENGL < 2/3 on $TARGET_FILE...\n${NC}"
                # Use sudo and tee to write lines to the file
                echo -e '#!/usr/bin/env bash\nLIBGL_ALWAYS_SOFTWARE=1 tabby'       | sudo tee "$TARGET_FILE" > /dev/null
                # Make the file executable
                sudo chmod +x "$TARGET_FILE"
                ;;
            vscodium)
                printf "${YELLOW}Installing vscodium...\n${NC}"

				# https://github.com/VSCodium/vscodium/issues/1710
                # vscodium from sources requires 8Gb memory to compile
                MEMMIN=8174650    
                MEMTOT=$(grep MemTotal /proc/meminfo | awk '{print $2}')
                if [ $MEMTOT -gt $MEMMIN ]
                then
                    printf "${YELLOW}Installing vscodium sources...\n${NC}"
                    yay -S vscodium --noconfirm
                else
                    printf "${YELLOW}Installing vscodium binary...\n${NC}"
                    yay -S vscodium-bin --noconfirm
                fi
                # --------------------------------------------------------------------------------------------------
                # OLD Script to replace marketplace in extensionsGallery on products.json
                # printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
                # cd /usr/local/sbin/
                # sudo git clone https://github.com/AlessandroPerazzetta/vscodium-json-updater
                # cd -
                # sudo /usr/local/sbin/vscodium-json-updater/update.sh
                # -------------------------------------------------------------------------------------------------- 
                # NEW Script to replace marketplace in extensionsGallery on products.json (local user config)
                mkdir -p ~/.config/VSCodium/
                bash -c "echo -e '{\n  \"nameShort\": \"Visual Studio Code\",\n  \"nameLong\": \"Visual Studio Code\",\n  \"extensionsGallery\": {\n    \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",\n    \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",\n    \"itemUrl\": \"https://marketplace.visualstudio.com/items\"\n  }\n}\n' > ~/.config/VSCodium/product.json"
                printf "${YELLOW}Installing vscodium MS marketplace ENV in /etc/profile.d/vscode-market.sh ...\n${NC}"
                sudo bash -c "echo -e 'export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'\nexport VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'\nexport VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'\nexport VSCODE_GALLERY_CONTROL_URL=''' > /etc/profile.d/vscode-market.sh"
                ;;
            vscodium_ext)
                printf "${YELLOW}VSCodium extensions ...\n${NC}"
                if ! command -v codium &> /dev/null
                then
                    printf "${RED}Installing/Uninstalling vscodium extensions failed, codium could not be found...\n${NC}"
                else
                    printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
                    export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'
                    export VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'
                    export VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'
                    export VSCODE_GALLERY_CONTROL_URL=''

                    # Extension removed from array:
                    #     Temporary removed, installed from file (v1.24.5) due to errors:
                    #     - https://github.com/VSCodium/vscodium/issues/2300
                    #     - https://github.com/getcursor/cursor/issues/2976
                    #    ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
                    printf "${LCYAN}Installing extension from file:\n${NC}"
                    mkdir -p /tmp/vscodium_exts/ && cd /tmp/vscodium_exts/
                    curl -s https://api.github.com/repos/jeanp413/open-remote-ssh/releases/latest | grep "browser_download_url.*vsix" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases/tags/v1.24.5 | grep "browser_download_url.*vsix"|grep "linux-x64" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    curl --compressed -fsSLo GitHub.copilot-1.257.1316.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot/1.257.1316/vspackage
                    curl --compressed -fsSLo GitHub.copilot-chat-0.23.2024120501.vsix https://marketplace.visualstudio.com/_apis/public/gallery/publishers/GitHub/vsextensions/copilot-chat/0.23.2024120501/vspackage
                    find . -type f -name "*.vsix" -exec codium --install-extension {} --force --log debug \;

                    declare -A VSCODEEXTlistAdd=(
                        ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
                        ["Even Better TOML: Fully-featured TOML support"]="tamasfe.even-better-toml"
                        ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
                        ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
                        ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
                        ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
                        ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
                        ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
                        ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
                        ["isort: Import organization support for Python files using isort."]="ms-python.isort"
                        ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
                        ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
                        ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
                        ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
                        ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
                        ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
                        ["Dependi: Empowers developers to efficiently manage dependencies and address vulnerabilities in Rust, Go, JavaScript, Typescript, PHP and Python projects."]="fill-labs.dependi"
                        ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
                        ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
                        ["Todo Tree: Show TODO, FIXME, etc. comment tags in a tree view"]="Gruntfuggly.todo-tree"
                        ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
                        ["Readable Indent"]="cnojima.readable-indent"
                        ["VSCode Great Icons"]="emmanuelbeziat.vscode-great-icons"
                        ["vscode-proto3"]="zxh404.vscode-proto3"
                    )
                    for i in "${!VSCODEEXTlistAdd[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistAdd[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        codium --install-extension ${VSCODEEXTlistAdd[$i]} --force --log debug
                        printf "\n${NC}"
                    done

                    printf "${YELLOW}Uninstalling vscodium extensions ...\n${NC}"
                    declare -A VSCODEEXTlistDel=(
                        ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
                        ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
                        ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
                        ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
                        ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
                    )
                    for i in "${!VSCODEEXTlistDel[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistDel[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        codium --uninstall-extension ${VSCODEEXTlistDel[$i]} --log debug
                        printf "\n${NC}"
                    done
                fi
                ;;
            vscode)
                printf "${YELLOW}Installing VSCode...\n${NC}"
                if ! command -v code &> /dev/null
                then
                    pacman -Sy code --noconfirm
                else
                    printf "${LGREEN}VSCode is already installed.\n${NC}"
                    # Ask user to reinstall or skip
                    read -p "Do you want to reinstall VSCode? (y/n): " REINSTALL_VSCODE
                    if [[ "$REINSTALL_VSCODE" =~ ^[Yy]$ ]]; then
                        printf "${YELLOW}Reinstalling VSCode...\n${NC}"
                        sudo pacman -Sy code --noconfirm
                    else
                        printf "${YELLOW}Skipping VSCode installation...\n${NC}"
                    fi
                fi
                ;;
            vscode_ext)
                printf "${YELLOW}VSCode extensions ...\n${NC}"
                if ! command -v code &> /dev/null
                then
                    printf "${RED}Installing/Uninstalling vscode extensions failed, code could not be found...\n${NC}"
                else
                    printf "${YELLOW}Installing vscode extensions ...\n${NC}"
                    # Extension removed from array:
                    #     Temporary removed, installed from file (v1.24.5) due to errors:
                    #     - https://github.com/VSCodium/vscodium/issues/2300
                    #     - https://github.com/getcursor/cursor/issues/2976
                    #    ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
                    printf "${LCYAN}Installing extension from file:\n${NC}"
                    mkdir -p /tmp/vscode_exts/ && cd /tmp/vscode_exts/
                    # curl -s https://api.github.com/repos/jeanp413/open-remote-ssh/releases/latest | grep "browser_download_url.*vsix" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    # curl -s https://api.github.com/repos/microsoft/vscode-cpptools/releases/tags/v1.24.5 | grep "browser_download_url.*vsix"|grep "linux-x64" | cut -d : -f 2,3 | tr -d \" | xargs curl -O -L
                    find . -type f -name "*.vsix" -exec code --install-extension {} --force --log debug \;

                    declare -A VSCODEEXTlistAdd=(
                        ["C/C++: C/C++ IntelliSense, debugging, and code browsing."]="ms-vscode.cpptools"
                        ["Better Comments: Improve your code commenting by annotating with alert, informational, TODOs, and more!"]="aaron-bond.better-comments"
                        ["Even Better TOML: Fully-featured TOML support"]="tamasfe.even-better-toml"
                        ["Prettier - Code formatter: Code formatter using prettier"]="esbenp.prettier-vscode"
                        ["Syntax Highlighter: Syntax highlighting based on Tree-sitter"]="evgeniypeshkov.syntax-highlighter"
                        ["Better C++ Syntax: The bleeding edge of the C++ syntax"]="jeff-hykin.better-cpp-syntax"
                        ["colorize: A vscode extension to help visualize css colors in files."]="kamikillerto.vscode-colorize"
                        ["indent-rainbow: Makes indentation easier to read"]="oderwat.indent-rainbow"
                        ["Serial Monitor: Send and receive text from serial ports."]="ms-vscode.vscode-serial-monitor"
                        ["Arduino: Arduino for Visual Studio Code Community Edition fork"]="vscode-arduino.vscode-arduino-community"
                        ["isort: Import organization support for Python files using isort."]="ms-python.isort"
                        ["Pylint: Linting support for Python files using Pylint."]="ms-python.pylint"
                        ["Python: Python language support with extension access points for IntelliSense (Pylance), Debugging (Python Debugger), linting, formatting, refactoring, unit tests, "]="ms-python.python"
                        ["Pylance: A performant, feature-rich language server for Python in VS Code"]="ms-python.vscode-pylance"
                        ["CodeLLDB: A native debugger powered by LLDB. Debug C++, Rust and other compiled languages."]="vadimcn.vscode-lldb"
                        ["Prettier - Code formatter (Rust): Prettier Rust is a code formatter that autocorrects bad syntax"]="jinxdash.prettier-rust"
                        ["rust-analyzer: Rust language support for Visual Studio Code"]="rust-lang.rust-analyzer"
                        ["Dependi: Empowers developers to efficiently manage dependencies and address vulnerabilities in Rust, Go, JavaScript, Typescript, PHP and Python projects."]="fill-labs.dependi"
                        ["Markdown Preview Enhanced: Markdown Preview Enhanced ported to vscode"]="shd101wyy.markdown-preview-enhanced"
                        ["Error Lens: Improve highlighting of errors, warnings and other language diagnostics."]="usernamehw.errorlens"
                        ["Todo Tree: Show TODO, FIXME, etc. comment tags in a tree view"]="Gruntfuggly.todo-tree"
                        ["Shades of Purple: 🦄 A professional theme suite with hand-picked & bold shades of purple for your VS Code editor and terminal apps."]="ahmadawais.shades-of-purple"
                        ["Readable Indent"]="cnojima.readable-indent"
                        ["VSCode Great Icons"]="emmanuelbeziat.vscode-great-icons"
                        ["vscode-proto3"]="zxh404.vscode-proto3"
                        ["Remote - SSH"]="ms-vscode-remote.remote-ssh"
                    )
                    for i in "${!VSCODEEXTlistAdd[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistAdd[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        code --install-extension ${VSCODEEXTlistAdd[$i]} --force --log debug
                        printf "\n${NC}"
                    done

                    printf "${YELLOW}Uninstalling vscode extensions ...\n${NC}"
                    declare -A VSCODEEXTlistDel=(
                        ["Jupyter: Jupyter notebook support, interactive programming and computing that supports Intellisense, debugging and more."]="ms-toolsai.jupyter"
                        ["Jupyter Keymap: Jupyter keymaps for notebooks"]="ms-toolsai.jupyter-keymap"
                        ["Jupyter Notebook Renderers: Renderers for Jupyter Notebooks (with plotly, vega, gif, png, svg, jpeg and other such outputs)"]="ms-toolsai.jupyter-renderers"
                        ["Jupyter Cell Tags: Jupyter Cell Tags support for VS Code"]="ms-toolsai.vscode-jupyter-cell-tags"
                        ["Jupyter Slide Show: Jupyter Slide Show support for VS Code"]="ms-toolsai.vscode-jupyter-slideshow"
                    )
                    for i in "${!VSCODEEXTlistDel[@]}"; do
                        #echo "Key: $i value: ${VSCODEEXTlistDel[$i]}"
                        printf "${LCYAN}- Extension: ${i}\n${NC}"
                        code --uninstall-extension ${VSCODEEXTlistDel[$i]} --log debug
                        printf "\n${NC}"
                    done
                fi
                ;;
            zed_editor)
                printf "${YELLOW}Installing Zed editor...\n${NC}"

                installation_path="/opt"
                channel="stable"
                platform="$(uname -s)"
                arch="$(uname -m)"
                if [ "$platform" = "Darwin" ]; then
                    platform="macos"
                elif [ "$platform" = "Linux" ]; then
                    platform="linux"
                else
                    printf "${RED}Unsupported platform $platform\n${NC}"
                    exit 1
                fi

                case "$platform-$arch" in
                    macos-arm64* | linux-arm64* | linux-armhf | linux-aarch64)
                        arch="aarch64"
                        ;;
                    macos-x86* | linux-x86* | linux-i686*)
                        arch="x86_64"
                        ;;
                    *)
                        printf "${RED}Unsupported platform or architecture\n${NC}"
                        exit 1
                        ;;
                esac

                printf "${LCYAN}* Downloading Zed ($channel) for $platform-$arch to $installation_path/zed-${channel}\n${NC}"
                tarball="zed-${platform}-${arch}.tar.gz"
                url="https://zed.dev/api/releases/${channel}/latest/${tarball}"
                curl -fL "$url" -o "/tmp/$tarball"

                # Check if $installation_path/zed-${channel} exists, if not try to create it, if fails try to create with sudo and grant permissions for the user
                if [ ! -d "$installation_path/zed-${channel}" ]; then
                    printf "${LCYAN}$installation_path/zed-${channel} does not exist. Creating it.\n${NC}"
                    sudo mkdir -p "$installation_path/zed-${channel}" || {
                        printf "${LRED} Failed to create $installation_path/zed-${channel}. Trying with sudo."
                        sudo mkdir -p "$installation_path/zed-${channel}" || {
                            printf "${RED} °°° Failed to create $installation_path/zed-${channel} even with sudo. Exiting.\n${NC}"
                            exit 1
                        }
                    }
                fi

                # Check if we have write permissions
                if [ ! -w "$installation_path/zed-${channel}" ]; then
                    printf "${LRED} No write permissions for $installation_path/zed-${channel}. Trying to change ownership with sudo.\n${NC}"
                    sudo chown -R "$(whoami)":"$(whoami)" "$installation_path/zed-${channel}" || {
                        printf "${RED} °°° Failed to change ownership of $installation_path/zed-${channel}. Exiting.\n${NC}"
                        exit 1
                    }
                fi

                # Extract tarball to installation_path/zed-${channel} getting rid of the top-level directory
                printf "${LCYAN} * Extracting Zed to $installation_path/zed-${channel}...\n${NC}"
                tar -xzf "/tmp/$tarball" -C "$installation_path/zed-${channel}" --strip-components=1

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LGREEN}"
                printf "Zed has been installed to $installation_path/zed-${channel}\n"
                printf "To run Zed from your terminal, add $installation_path/zed-${channel}/bin to your PATH\n"
                printf "For example, you can add the following line to your shell profile:\n"
                printf 'export PATH="$HOME/.local/bin:$PATH"\n'
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"

                # Install .desktop file and icons for desktop integration
                if [ "$platform" = "linux" ]; then
                    if [ -n "${XDG_DATA_HOME:-}" ]; then
                        data_home="$XDG_DATA_HOME"
                    else
                        data_home="$HOME/.local/share"
                    fi
                    mkdir -p "$data_home/applications/"
                    cp "$installation_path/zed-${channel}/share/applications/zed.desktop" "$data_home/applications/dev.zed.Zed.desktop"
                    sed -i "s|Icon=zed|Icon=$installation_path/zed-${channel}/share/icons/hicolor/512x512/apps/zed.png|g" "$data_home/applications/dev.zed.Zed.desktop"
                    sed -i "s|Exec=zed|Exec=$installation_path/zed-${channel}/libexec/zed-editor|g" "$data_home/applications/dev.zed.Zed.desktop"
                fi
                ;;
            grpcurl)
                printf "${YELLOW}Installing grpcurl...\n${NC}"
                yay -Sy grpcurl-bin --noconfirm
                ;;
            unison)
                printf "${YELLOW}Installing unison and unison-gtk...\n${NC}"
                yay -Sy unison unison-gtk --noconfirm
                ;;
            marktext)
                printf "${YELLOW}Installing Marktext editor...\n${NC}"
                sudo mkdir -p /opt/marktext/
                curl -s https://api.github.com/repos/marktext/marktext/releases/latest |grep "browser_download_url.*AppImage" |cut -d : -f 2,3 |tr -d \"| xargs -n 1 sudo curl -L -o /opt/marktext/marktext
                #sudo curl -fsSLo /opt/marktext/logo.png https://github.com/marktext/marktext/blob/b75895cdd1a51638f2e67b222b266ff8b9cb9d69/static/logo-96px.png
                sudo chmod +x /opt/marktext/marktext
                sudo bash -c "echo -e '[Desktop Entry]\nName=M\nGenericName=MQTT client\nComment=An all-round MQTT client that provides a structured topic overviewCategories=Development;\nTerminal=false\nType=Application\nPath=/opt/mqtt-explorer/\nExec=/opt/mqtt-explorer/mqtt-explorer\nStartupWMClass=mqtt-explorer\nStartupNotify=true\nKeywords=MQTT\nIcon=/opt/mqtt-explorer/icon.png' >> /usr/share/applications/mqtt-explorer.desktop"
                curl -L https://raw.githubusercontent.com/marktext/marktext/develop/resources/linux/marktext.desktop -o ~/.local/share/applications/marktext.desktop
                sed -i -e "s/Exec=marktext/Exec=\/opt\/marktext\/marktext/g" ~/.local/share/applications/marktext.desktop
                sed -i -e "s/Icon=marktext/Icon=\/opt\/marktext\/marktext/g" ~/.local/share/applications/marktext.desktop
                update-desktop-database ~/.local/share/applications/
                ;;
            dbeaver)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo pacman -Sy dbeaver --noconfirm
                ;;
            smartgit)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                yay -S smartgit --noconfirm
                ;;
            arduino_cli)
                printf "${YELLOW}Installing arduino-cli...\n${NC}"
                sudo mkdir -p /opt/arduino-cli/
                sudo chown "$CURRENT_USER":"$CURRENT_USER" /opt/arduino-cli
                curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | BINDIR=/opt/arduino-cli sh
                ;; 
            keepassxc)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo pacman -Sy keepassxc --noconfirm
                ;;
            qownnotes)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                yay -S qownnotes --noconfirm
                ;;
            virtualbox)
                printf "${YELLOW}Installing virtualbox...\n${NC}"
                sudo pacman -Sy virtualbox virtualbox-guest-iso --noconfirm
                sudo adduser $CURRENT_USER vboxusers
                sudo adduser $CURRENT_USER disk
                sudo systemctl enable vboxweb.service 

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Installing Virtualbox Extension Pack \n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                yay -S virtualbox-ext-oracle --noconfirm
                ;;
            kicad)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo pacman -Sy kicad kicad-library --noconfirm
                ;;
            freecad)
                printf "${YELLOW}Installing freecad...\n${NC}"
                sudo pacman -Sy freecad --noconfirm
                ;;
            telegram)
                printf "${YELLOW}Installing telegram...\n${NC}"
                sudo pacman -Sy telegram-desktop --noconfirm
                ;;
            rust)
                printf "${YELLOW}Installing rust...\n${NC}"
                if ! command -v rustc &> /dev/null
                then
                    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                else
                    printf "${RED}Installing rust, rustc found. Rust already present...\n${NC}"
                fi
                ;;
            py_36)
                printf "${YELLOW}Installing python 3.6 (AUR install)...\n${NC}"
                yay -S python36 --noconfirm
                ;;
            py_38)
                printf "${YELLOW}Installing python 3.8 (AUR install)...\n${NC}"
                yay -S python38 --noconfirm
                ;;
            qt_stuff)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo pacman -Sy qtcreator --noconfirm
                ;;
            ssh_alive)
                printf "${YELLOW}Installing ssh alive settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_ALIVE
                sudo sed -i -e "s/ServerAliveInterval 240/ServerAliveInterval 15/g" /etc/ssh/ssh_config
                sudo bash -c 'echo "    ServerAliveCountMax=1" >> /etc/ssh/ssh_config'
                ;;
            ssh_skip_hosts_check)
                printf "${YELLOW}Installing ssh skip hosts check settings...\n${NC}"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Original copy of ssh_config is available in /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS\n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
                sudo cp /etc/ssh/ssh_config /etc/ssh/ssh_config.ORIGINAL_PRE_HOSTS_CHECKS
                sudo bash -c 'echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config'
                sudo bash -c 'echo "    UserKnownHostsFile /dev/null" >> /etc/ssh/ssh_config'
                ;;
            borgbackup_vorta)
                printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
                yay -S borgbackup --noconfirm
                yay -S vorta --noconfirm
                ;;
            spotube)
                printf "${YELLOW}Installing spotube...\n${NC}"
                yay -S spotube-bin --noconfirm
                ;;
            fonts)
                printf "${YELLOW}Installing fonts...\n${NC}"
                yay -S ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd --noconfirm
                ;;    
        esac
    done
else
        exit 0
fi
