#!/usr/bin/env bash
# Module: py_38
# DESC: python 3.8 (AUR install)
# DEFAULT: off
# ORDER: 500
# Called by install-packages.sh orchestrator

install_py_38() {
    printf "${YELLOW}Installing python 3.8 (AUR install)...\n${NC}"
    yay -S python38 --noconfirm
}
