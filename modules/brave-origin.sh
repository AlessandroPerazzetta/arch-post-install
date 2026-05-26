#!/usr/bin/env bash
# Module: brave-origin
# DESC: brave-origin-browser
# DEFAULT: off
# ORDER: 250
# Called by install-packages.sh orchestrator

install_brave_origin() {
    printf "${YELLOW}Installing brave-origin-browser...\n${NC}"
    yay -Sy brave-origin-nightly-bin --noconfirm
}
