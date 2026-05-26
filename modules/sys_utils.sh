#!/usr/bin/env bash
# Module: sys_utils
# DESC: system utils
# DEFAULT: on
# ORDER: 30
# Called by install-packages.sh orchestrator

install_sys_utils() {
    printf "${YELLOW}Installing system utils...\n${NC}"
    sudo pacman -Sy bwm-ng htop --noconfirm
}
