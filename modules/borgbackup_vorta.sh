#!/usr/bin/env bash
# Module: borgbackup_vorta
# DESC: borgbackup + vorta gui
# DEFAULT: on
# ORDER: 540
# Called by install-packages.sh orchestrator

install_borgbackup_vorta() {
    printf "${YELLOW}Installing borgbackup and vorta gui...\n${NC}"
    yay -S borgbackup --noconfirm
    yay -S vorta --noconfirm
}
