#!/usr/bin/env bash
# Module: telegram
# DESC: telegram
# DEFAULT: on
# ORDER: 470
# Called by install-packages.sh orchestrator

install_telegram() {
    printf "${YELLOW}Installing telegram...\n${NC}"
    sudo pacman -Sy telegram-desktop --noconfirm
}
