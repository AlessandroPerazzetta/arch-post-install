#!/usr/bin/env bash
# Module: spotube
# DESC: spotube (AUR install)
# DEFAULT: off
# ORDER: 550
# Called by install-packages.sh orchestrator

install_spotube() {
    printf "${YELLOW}Installing spotube...\n${NC}"
    yay -S spotube-bin --noconfirm
}
