#!/usr/bin/env bash
# Module: qownnotes
# DESC: qownnotes
# DEFAULT: on
# ORDER: 430
# Called by install-packages.sh orchestrator

install_qownnotes() {
    printf "${YELLOW}Installing qownnotes...\n${NC}"
    yay -S qownnotes --noconfirm
}
