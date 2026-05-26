#!/usr/bin/env bash
# Module: ferrite
# DESC: ferrite editor
# DEFAULT: on
# ORDER: 360
# Called by install-packages.sh orchestrator

install_ferrite() {
    printf "${YELLOW}Installing Ferrite editor...\n${NC}"
    yay -S ferrite-bin --noconfirm
}
