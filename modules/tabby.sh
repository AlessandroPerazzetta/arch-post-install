#!/usr/bin/env bash
# Module: tabby
# DESC: tabby
# DEFAULT: on
# ORDER: 180
# Called by install-packages.sh orchestrator

install_tabby() {
    printf "${YELLOW}Installing tabby...\n${NC}"
    sudo pacman -Sy tabby-terminal --noconfirm
}
