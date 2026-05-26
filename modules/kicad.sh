#!/usr/bin/env bash
# Module: kicad
# DESC: kicad
# DEFAULT: on
# ORDER: 450
# Called by install-packages.sh orchestrator

install_kicad() {
    printf "${YELLOW}Installing kicad...\n${NC}"
    sudo pacman -Sy kicad kicad-library --noconfirm
}
