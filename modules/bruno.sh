#!/usr/bin/env bash
# Module: bruno
# DESC: Bruno The Git-native API client (AUR install)
# DEFAULT: on
# ORDER: 390
# Called by install-packages.sh orchestrator

install_bruno() {
    printf "${YELLOW}Installing Bruno The Git-native API client...\n${NC}"
    yay -S bruno-bin --noconfirm
}
