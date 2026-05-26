#!/usr/bin/env bash
# Module: tmux
# DESC: tmux
# DEFAULT: on
# ORDER: 50
# Called by install-packages.sh orchestrator

install_tmux() {
    printf "${YELLOW}Installing tmux...\n${NC}"
    sudo pacman -Sy tmux --noconfirm
}
