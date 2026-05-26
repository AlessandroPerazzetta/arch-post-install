#!/usr/bin/env bash
# Module: py_36
# DESC: python 3.6 (AUR install)
# DEFAULT: off
# ORDER: 490
# Called by install-packages.sh orchestrator

install_py_36() {
    printf "${YELLOW}Installing python 3.6 (AUR install)...\n${NC}"
    yay -S python36 --noconfirm
}
