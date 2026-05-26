#!/usr/bin/env bash
# Module: freecad
# DESC: freecad
# DEFAULT: on
# ORDER: 460
# Called by install-packages.sh orchestrator

install_freecad() {
    printf "${YELLOW}Installing freecad...\n${NC}"
    sudo pacman -Sy freecad --noconfirm
}
