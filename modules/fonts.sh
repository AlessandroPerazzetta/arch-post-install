#!/usr/bin/env bash
# Module: fonts
# DESC: fonts (AUR install)
# DEFAULT: on
# ORDER: 560
# Called by install-packages.sh orchestrator

install_fonts() {
    printf "${YELLOW}Installing fonts...\n${NC}"
    yay -S ttf-nerd-fonts-symbols ttf-jetbrains-mono-nerd --noconfirm
}
