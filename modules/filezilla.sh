#!/usr/bin/env bash
# Module: filezilla
# DESC: filezilla
# DEFAULT: on
# ORDER: 200
# Called by install-packages.sh orchestrator

install_filezilla() {
    printf "${YELLOW}Installing filezilla...\n${NC}"
    sudo pacman -Sy filezilla --noconfirm
}
