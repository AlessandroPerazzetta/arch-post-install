#!/usr/bin/env bash
# Module: keepassxc
# DESC: keepassxc
# DEFAULT: on
# ORDER: 420
# Called by install-packages.sh orchestrator

install_keepassxc() {
    printf "${YELLOW}Installing keepassxc...\n${NC}"
    sudo pacman -Sy keepassxc --noconfirm
}
