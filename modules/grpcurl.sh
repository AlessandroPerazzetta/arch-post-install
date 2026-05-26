#!/usr/bin/env bash
# Module: grpcurl
# DESC: grpcurl (AUR install)
# DEFAULT: on
# ORDER: 330
# Called by install-packages.sh orchestrator

install_grpcurl() {
    printf "${YELLOW}Installing grpcurl...\n${NC}"
    yay -Sy grpcurl-bin --noconfirm
}
