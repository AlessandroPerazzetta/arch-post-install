#!/usr/bin/env bash
# Module: lazygit
# DESC: lazygit
# DEFAULT: off
# ORDER: 215
# Called by install-packages.sh orchestrator

install_lazygit() {
    printf "${YELLOW}Installing lazygit...\n${NC}"
    sudo pacman -Sy lazygit --noconfirm
}
