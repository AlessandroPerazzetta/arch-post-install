#!/usr/bin/env bash
# Module: sys_serial
# DESC: system Serial permission
# DEFAULT: on
# ORDER: 20
# Called by install-packages.sh orchestrator

install_sys_serial() {
    printf "${YELLOW}Installing python pyserial...\n${NC}"
    pacman -S python-pyserial                
    printf "${YELLOW}Installing system permissions to allow user open Serial...\n${NC}"
    grep -Ei "^uucp" /etc/group;
    if [ $? -eq 0 ]; then
        printf "${YELLOW}uucp Group Exists add current user...\n${NC}"
        if id -nG "$CURRENT_USER" | grep -qw "uucp"; then
            printf "${YELLOW}User is already in uucp group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
        else
            printf "${YELLOW}Add user to uucp group (ref: /dev/ttyUSBx Error opening serial port)...\n${NC}"
            sudo usermod -a -G uucp $CURRENT_USER
        fi
    else
        printf "${RED}uucp Group Not Exists can't add current user...\n${NC}"
    fi
}
