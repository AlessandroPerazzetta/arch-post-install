#!/usr/bin/env bash
# Module: tmux_res
# DESC: tmux resources
# DEFAULT: on
# ORDER: 60
# REQUIRE: tmux
# Called by install-packages.sh orchestrator

install_tmux_res() {
    printf "${YELLOW}Installing tmux resources...\n${NC}"
    # curl -fsSLo ~/.tmux.conf https://raw.githubusercontent.com/AlessandroPerazzetta/dotfiles/main/.tmux.conf
    printf "${YELLOW}Installing tmux resources from git sparse checkout...\n${NC}"
    mkdir -p /tmp/dotfiles-tmux.git
    cd /tmp/dotfiles-tmux.git
    git init
    git remote add origin -f https://github.com/AlessandroPerazzetta/dotfiles
    git sparse-checkout set tmux
    git pull origin main
    mv tmux ~/.config/
    cd -
    rm -rf /tmp/dotfiles-tmux.git
}
