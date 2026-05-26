#!/usr/bin/env bash
# Module: neovim
# DESC: neovim
# DEFAULT: on
# ORDER: 90
# Called by install-packages.sh orchestrator

install_neovim() {
    printf "${YELLOW}Installing neovim...\n${NC}"
    sudo pacman -Sy neovim --noconfirm
    printf "${YELLOW}Installing neovim resources...\n${NC}"
    mkdir -p ~/.config/nvim/
    curl -fsSLo ~/.config/nvim/init.vim https://raw.githubusercontent.com/AlessandroPerazzetta/neovim-res/main/.config/nvim/init.vim
    printf "${YELLOW}Set nvim as default editor...\n${NC}"
    sudo sed -i -e "s/EDITOR=nano/EDITOR=vi/g" /etc/environment
    printf "${YELLOW}Create vi nvim symbolic link...\n${NC}"
    sudo ln -s /usr/bin/nvim /usr/local/sbin/vi
}
