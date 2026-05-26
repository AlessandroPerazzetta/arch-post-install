#!/usr/bin/env bash
# Module: vscode
# DESC: vscode
# DEFAULT: on
# ORDER: 300
# Called by install-packages.sh orchestrator

install_vscode() {
    printf "${YELLOW}Installing VSCode...\n${NC}"
    if ! command -v code &> /dev/null
    then
        pacman -Sy code --noconfirm
    else
        printf "${LGREEN}VSCode is already installed.\n${NC}"
        # Ask user to reinstall or skip
        read -p "Do you want to reinstall VSCode? (y/n): " REINSTALL_VSCODE
        if [[ "$REINSTALL_VSCODE" =~ ^[Yy]$ ]]; then
            printf "${YELLOW}Reinstalling VSCode...\n${NC}"
            sudo pacman -Sy code --noconfirm
        else
            printf "${YELLOW}Skipping VSCode installation...\n${NC}"
        fi
    fi
}
