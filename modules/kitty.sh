#!/usr/bin/env bash
# Module: kitty
# DESC: kitty
# DEFAULT: off
# ORDER: 130
# Called by install-packages.sh orchestrator

install_kitty() {
    printf "${YELLOW}Installing kitty terminal...\n${NC}"
    sudo pacman -Sy kitty --noconfirm
}
