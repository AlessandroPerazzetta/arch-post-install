#!/usr/bin/env bash
# Module: brave-origin_ext
# DESC: brave-origin-browser extensions
# DEFAULT: off
# ORDER: 260
# REQUIRE: brave-origin
# Called by install-packages.sh orchestrator

install_brave_origin_ext() {
    printf "${YELLOW}Installing brave-origin-browser extensions...\n${NC}"
    install_brave_extensions "/opt/brave.com/brave-origin-nightly"
}
