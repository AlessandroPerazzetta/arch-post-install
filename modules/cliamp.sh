#!/usr/bin/env bash
# Module: cliamp
# DESC: cliamp (AUR install)
# DEFAULT: off
# ORDER: 580
# Called by install-packages.sh orchestrator

install_cliamp() {
    printf "${YELLOW}Installing cliamp...\n${NC}"
    yay -S cliamp --noconfirm
}
