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

sudo pacman -Sy
sudo pacman -S dialog

cmd=(dialog --title "Automated packages installation" --backtitle "Mint Post Install" --no-collapse --separate-output --checklist "Select options:" 22 76 16)
options=(
0 "Personal resources" on
1 "bwm-ng" on
2 "screen" on
3 "neovim" on
4 "filezilla" on
5 "meld" on
6 "vlc" on
7 "htop" on
8 "brave-browser" on
9 "brave-browser extensions" on
10 "remmina" on
11 "vscodium" on
12 "vscodium extensions" on
13 "dbeaver" on
14 "smartgit" on
15 "keepassxc" on
16 "qownnotes" on
17 "virtualbox" on
18 "kicad" on
19 "freecad" on
20 "telegram" on
21 "rust" on
22 "python 3.6 (AUR install)" off
23 "python 3.8 (AUR install)" off
24 "qtcreator + qt5" off
25 "borgbackup + vorta gui" on)

choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]
then
    printf "${YELLOW}Updating system...\n${NC}"
    sleep 1
    sudo pacman -Syyu

    printf "${YELLOW}Install required packages...\n${NC}"
    sleep 1
    sudo pacman -Sy --needed base-devel git openssh
    sudo pacman -Sy xed curl python-pyserial jq wget
    sudo systemctl enable sshd
    sudo systemctl start sshd

    printf "${YELLOW}Install AUR packages...\n${NC}"
    sleep 1
    git clone https://aur.archlinux.org/yay-bin.git
    cd yay-bin
    makepkg -si
    yay -Syu

    grep -Ei "^dialout" /etc/group;
    if [ $? -eq 0 ]; then
        printf "${YELLOW}Dialout Group Exists add current user...\n${NC}"
        if id -nG "$CURRENT_USER" | grep -qw "dialout"; then
            printf "${YELLOW}User is already in dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
        else
            printf "${YELLOW}Add user to dialout group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
            sudo usermod -a -G dialout $CURRENT_USER
        fi
    else
        printf "${RED}Dialout Group Not Exists can't add current user...\n${NC}"
    fi

    for choice in $choices
    do
        case $choice in
            0)
                printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
                printf "${YELLOW}Installing aliase resources...\n${NC}"
                printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bashrc-personal
                printf "${YELLOW}Installing Xed resources...\n${NC}"
                mkdir -p ~/.local/share/xed/styles/
                curl -fsSLo ~/.local/share/xed/styles/kat-ng.xml https://raw.githubusercontent.com/AlessandroPerazzetta/xed-themes/main/kat-ng.xml
                ;;
            1)
                printf "${YELLOW}Installing bwm-ng...\n${NC}"
                sudo pacman -Sy bwm-ng
                ;;
            2)
                printf "${YELLOW}Installing screen...\n${NC}"
                sudo pacman -Sy screen
                ;;
            3)
                printf "${YELLOW}Installing neovim...\n${NC}"
                sudo pacman -Sy neovim

                printf "${YELLOW}Installing neovim resources...\n${NC}"
                mkdir -p ~/.config/nvim/
                curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim

                printf "${YELLOW}Set nvim as default editor...\n${NC}"
                sudo sed -i -e "s/EDITOR=nano/EDITOR=vi/g" /etc/environment
                printf "${YELLOW}Create vi nvim symbolic link...\n${NC}"
                sudo ln -s /usr/bin/nvim /usr/local/sbin/vi
                ;;
            4)
                printf "${YELLOW}Installing filezilla...\n${NC}"
                sudo pacman -Sy filezilla
                ;;
            5)
                printf "${YELLOW}Installing meld...\n${NC}"
                sudo pacman -Sy meld
                ;;
            6)
                printf "${YELLOW}Installing vlc...\n${NC}"
                sudo pacman -Sy vlc
                
                printf "${YELLOW}Installing vlc media library...\n${NC}"
                mkdir -p ~/.local/share/vlc/
                curl -fsSLo ~/.local/share/vlc/ml.xspf https://raw.githubusercontent.com/AlessandroPerazzetta/vlc-media-library/main/ml.xspf
                ;;
            7)
                printf "${YELLOW}Installing htop...\n${NC}"
                sudo pacman -Sy htop
                ;;
            8)
                printf "${YELLOW}Installing brave-browser...\n${NC}"
                yay -S brave-bin --noconfirm
                ;;
            9)
                printf "${YELLOW}Installing brave-browser extensions...\n${NC}"
                BRAVE_PATH="/opt/brave-bin"
                BRAVE_EXTENSIONS_PATH="$BRAVE_PATH/extensions"
                if [ -d "$BRAVE_PATH" ]
                then
                    sudo mkdir -p ${BRAVE_EXTENSIONS_PATH}
                    declare -A EXTlist=(
                        ["bypass-adblock-detection"]="lppagnomjcaohgkfljlebenbmbdmbkdj"
                        ["hls-downloader"]="hkbifmjmkohpemgdkknlbgmnpocooogp"
                        ["i-dont-care-about-cookies"]="fihnjjcciajhdojfnbdddfaoknhalnja"
                        ["keepassxc-browser"]="oboonakemofpalcgghocfoadofidjkkk"
                        ["session-buddy"]="edacconmaakjimmfgnblocblbcdcpbko"
                        ["the-marvellous-suspender"]="noogafoofpebimajpfpamcfhoaifemoa"
                        ["url-tracking-stripper-red"]="flnagcobkfofedknnnmofijmmkbgfamf"
                        ["video-downloader-plus"]="njgehaondchbmjmajphnhlojfnbfokng"
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
            10)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo pacman -Sy remmina
                ;;
            11)
                printf "${YELLOW}Installing vscodium...\n${NC}"
                sudo pacman -Sy vscodium

                printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
                sudo curl -fsSLo /usr/local/sbin/vscodium-json-updater.sh https://raw.githubusercontent.com/AlessandroPerazzetta/vscodium-json-updater/main/update.sh
                sudo chmod +x /usr/local/sbin/vscodium-json-updater.sh
                sudo /usr/local/sbin/vscodium-json-updater.sh

                printf "${YELLOW}Installing nemo action for vscodium...\n${NC}"
                #sudo wget https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action -O ~/.local/share/nemo/actions/codium.nemo_action
                mkdir -p ~/.local/share/nemo/actions/
                curl -fsSLo ~/.local/share/nemo/actions/codium.nemo_action https://raw.githubusercontent.com/AlessandroPerazzetta/nemo-actions-vscodium-launcher/main/codium.nemo_action
                ;;
            12)
                printf "${YELLOW}Installing vscodium extensions ...\n${NC}"
                if ! command -v codium &> /dev/null
                then
                    printf "${RED}Installing vscodium extensions failed, codium could not be found...\n${NC}"
                else
                    codium --install-extension bungcip.better-toml
                    codium --install-extension rust-lang.rust-analyzer
                    codium --install-extension jinxdash.prettier-rust
                    codium --install-extension kogia-sima.vscode-sailfish
                    codium --install-extension ms-python.python
                    codium --install-extension ms-python.vscode-pylance
                    codium --install-extension ms-vscode.cpptools
                    codium --install-extension serayuzgur.crates
                    codium --install-extension usernamehw.errorlens
                    codium --install-extension vadimcn.vscode-lldb
                    codium --install-extension vsciot-vscode.vscode-arduino
                    codium --install-extension ahmadawais.shades-of-purple
                fi
                ;;
            13)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo pacman -Sy dbeaver
                ;;
            14)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                yay -S smartgit --noconfirm
                ;;
            15)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo pacman -Sy keepassxc
                ;;
            16)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                yay -S qownnotes --noconfirm
                ;;
            17)
                printf "${YELLOW}Installing virtualbox...\n${NC}"
                sudo pacman -Sy virtualbox virtualbox-guest-iso
                sudo adduser $CURRENT_USER vboxusers
                sudo adduser $CURRENT_USER disk
                sudo systemctl enable vboxweb.service 

                printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
                printf "Installing Virtualbox Extension Pack \n"
                printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
                yay -S virtualbox-ext-oracle --noconfirm
                ;;
            18)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo pacman -Sy kicad kicad-library
                ;;
            19)
                printf "${YELLOW}Installing freecad...\n${NC}"
                sudo pacman -Sy freecad
                ;;
            20)
                printf "${YELLOW}Installing telegram...\n${NC}"
                sudo pacman -Sy telegram-desktop
                ;;
            21)
                printf "${YELLOW}Installing rust...\n${NC}"
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                ;;
            22)
                printf "${YELLOW}Installing python 3.6 (AUR install)...\n${NC}"
                yay -S python36 --noconfirm
                ;;
            23)
                printf "${YELLOW}Installing python 3.8 (AUR install)...\n${NC}"
                yay -S python38 --noconfirm
                ;;
            24)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo pacman -Sy qtcreator
                ;;
            25)
                printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
                yay -S borgbackup --noconfirm
                yay -S vorta --noconfirm
                ;;
        esac
    done
else
        exit 0
fi
