#!/usr/bin/env bash
# Module: remmina
# DESC: remmina
# DEFAULT: on
# ORDER: 270
# Called by install-packages.sh orchestrator

install_remmina() {
    printf "${YELLOW}Installing remmina...\n${NC}"
    sudo pacman -Sy remmina --noconfirm
}
