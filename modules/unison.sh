#!/usr/bin/env bash
# Module: unison
# DESC: unison + unison-gtk (AUR install)
# DEFAULT: on
# ORDER: 340
# Called by install-packages.sh orchestrator

install_unison() {
    printf "${YELLOW}Installing unison and unison-gtk...\n${NC}"
    yay -Sy unison unison-gtk --noconfirm
}
