#!/usr/bin/env bash
# Module: brave
# DESC: brave-browser
# DEFAULT: on
# ORDER: 230
# Called by install-packages.sh orchestrator

install_brave() {
    printf "${YELLOW}Installing brave-browser...\n${NC}"
    yay -S brave-bin --noconfirm
}
