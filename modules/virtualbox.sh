#!/usr/bin/env bash
# Module: virtualbox
# DESC: virtualbox
# DEFAULT: on
# ORDER: 440
# Called by install-packages.sh orchestrator

install_virtualbox() {
    printf "${YELLOW}Installing virtualbox...\n${NC}"
    sudo pacman -Sy virtualbox virtualbox-guest-iso --noconfirm
    sudo adduser $CURRENT_USER vboxusers
    sudo adduser $CURRENT_USER disk
    sudo systemctl enable vboxweb.service 

    printf "${LCYAN}--------------------------------------------------------------------------------\n${LRED}"
    printf "Installing Virtualbox Extension Pack \n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    yay -S virtualbox-ext-oracle --noconfirm
}
