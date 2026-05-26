#!/usr/bin/env bash
# Module: personal_res
# DESC: personal resources
# DEFAULT: on
# ORDER: 10
# Called by install-packages.sh orchestrator

install_personal_res() {
    printf "${YELLOW}Installing PERSONAL RESOURCES...\n${NC}"
    printf "${YELLOW}Installing aliase resources...\n${NC}"
    printf "alias l='ls -lah'\nalias cls='clear'" >> ~/.bashrc-personal
}
