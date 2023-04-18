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
9 "remmina" on
10 "vscodium" on
11 "dbeaver" on
12 "smartgit" on
13 "keepassxc" on
14 "qownnotes" on
15 "virtualbox" on
16 "kicad" on
17 "telegram" on
18 "rust" on
19 "python 3.6.15 (src install)" off
20 "qtcreator + qt5" off)

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
        echo ""
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
                sudo pacman -Sy brave-browser
                ;;
            9)
                printf "${YELLOW}Installing remmina...\n${NC}"
                sudo pacman -Sy remmina
                ;;
            10)
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
            11)
                printf "${YELLOW}Installing dbeaver...\n${NC}"
                sudo pacman -Sy dbeaver
                ;;
            12)
                printf "${YELLOW}Installing smartgit...\n${NC}"
                yay -S smartgit --noconfirm
                ;;
            13)
                printf "${YELLOW}Installing keepassxc...\n${NC}"
                sudo pacman -Sy keepassxc
                ;;
            14)
                printf "${YELLOW}Installing qownnotes...\n${NC}"
                yay -S qownnotes --noconfirm
                ;;
            15)
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
            16)
                printf "${YELLOW}Installing kicad...\n${NC}"
                sudo pacman -Sy kicad kicad-library
                ;;
            17)
                printf "${YELLOW}Installing telegram...\n${NC}"
                sudo pacman -Sy telegram-desktop
                ;;
            18)
                printf "${YELLOW}Installing rust...\n${NC}"
                curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
                ;;
            19)
                printf "${YELLOW}Installing python 3.6.15 (src install)...\n${NC}"
                yay -S python36 --noconfirm
                ;;
            20)
                printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
                sudo pacman -Sy qtcreator
                ;;
        esac
    done
else
        exit 0
fi
