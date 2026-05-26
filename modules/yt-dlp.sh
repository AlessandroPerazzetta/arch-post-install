#!/usr/bin/env bash
# Module: yt-dlp
# DESC: yt-dlp (AUR install)
# DEFAULT: on
# ORDER: 570
# Called by install-packages.sh orchestrator

install_yt_dlp() {
    printf "${YELLOW}Installing yt-dlp...\n${NC}"
    yay -S yt-dlp --noconfirm
}
