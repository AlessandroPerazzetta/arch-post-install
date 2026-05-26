#!/usr/bin/env bash
# Module: mqtt_explorer
# DESC: MQTT Explorer (AUR install)
# DEFAULT: on
# ORDER: 380
# Called by install-packages.sh orchestrator

install_mqtt_explorer() {
    printf "${YELLOW}Installing MQTT Explorer...\n${NC}"
    yay -S mqtt-explorer-bin --noconfirm
}
