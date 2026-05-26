#!/usr/bin/env bash
# Module: meld
# DESC: meld
# DEFAULT: on
# ORDER: 210
# Called by install-packages.sh orchestrator

install_meld() {
    printf "${YELLOW}Installing meld...\n${NC}"
    sudo pacman -Sy meld --noconfirm
}
