#!/usr/bin/env bash
# Module: alacritty
# DESC: alacritty
# DEFAULT: on
# ORDER: 160
# Called by install-packages.sh orchestrator

install_alacritty() {
    printf "${YELLOW}Installing alacritty terminal...\n${NC}"
    sudo pacman -Sy alacritty --noconfirm
}
