#!/usr/bin/env bash
# Module: screen
# DESC: screen
# DEFAULT: on
# ORDER: 40
# Called by install-packages.sh orchestrator

install_screen() {
    printf "${YELLOW}Installing screen...\n${NC}"
    sudo pacman -Sy screen --noconfirm
}
