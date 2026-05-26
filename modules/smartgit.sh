#!/usr/bin/env bash
# Module: smartgit
# DESC: smartgit
# DEFAULT: off
# ORDER: 400
# Called by install-packages.sh orchestrator

install_smartgit() {
    printf "${YELLOW}Installing smartgit...\n${NC}"
    yay -S smartgit --noconfirm
}
