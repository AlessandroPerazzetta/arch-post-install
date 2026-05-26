#!/usr/bin/env bash
# Module: dbeaver
# DESC: dbeaver
# DEFAULT: on
# ORDER: 370
# Called by install-packages.sh orchestrator

install_dbeaver() {
    printf "${YELLOW}Installing dbeaver...\n${NC}"
    sudo pacman -Sy dbeaver --noconfirm
}
