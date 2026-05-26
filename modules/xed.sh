#!/usr/bin/env bash
# Module: xed
# DESC: xed
# DEFAULT: on
# ORDER: 100
# Called by install-packages.sh orchestrator

install_xed() {
    printf "${YELLOW}Installing xed...\n${NC}"
    sudo pacman -Sy xed --noconfirm
}
