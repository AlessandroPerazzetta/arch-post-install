#!/usr/bin/env bash
# Module: qt_stuff
# DESC: qtcreator + qt5
# DEFAULT: off
# ORDER: 510
# Called by install-packages.sh orchestrator

install_qt_stuff() {
    printf "${YELLOW}Installing qtcreator, qt5 and related stuff, cmake...\n${NC}"
    sudo pacman -Sy qtcreator --noconfirm
}
