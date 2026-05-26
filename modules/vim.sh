#!/usr/bin/env bash
# Module: vim
# DESC: vim
# DEFAULT: on
# ORDER: 70
# Called by install-packages.sh orchestrator

install_vim() {
    printf "${YELLOW}Installing vim...\n${NC}"
    sudo pacman -Sy vim --noconfirm
}
