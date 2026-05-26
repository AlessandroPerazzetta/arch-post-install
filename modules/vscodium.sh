#!/usr/bin/env bash
# Module: vscodium
# DESC: vscodium
# DEFAULT: off
# ORDER: 280
# Called by install-packages.sh orchestrator

install_vscodium() {
    printf "${YELLOW}Installing vscodium...\n${NC}"

	# https://github.com/VSCodium/vscodium/issues/1710
    # vscodium from sources requires 8Gb memory to compile
    MEMMIN=8174650    
    MEMTOT=$(grep MemTotal /proc/meminfo | awk '{print $2}')
    if [ $MEMTOT -gt $MEMMIN ]
    then
        printf "${YELLOW}Installing vscodium sources...\n${NC}"
        yay -S vscodium --noconfirm
    else
        printf "${YELLOW}Installing vscodium binary...\n${NC}"
        yay -S vscodium-bin --noconfirm
    fi
    # --------------------------------------------------------------------------------------------------
    # OLD Script to replace marketplace in extensionsGallery on products.json
    # printf "${YELLOW}Installing vscodium extension gallery updater...\n${NC}"
    # cd /usr/local/sbin/
    # sudo git clone https://github.com/AlessandroPerazzetta/vscodium-json-updater
    # cd -
    # sudo /usr/local/sbin/vscodium-json-updater/update.sh
    # -------------------------------------------------------------------------------------------------- 
    # NEW Script to replace marketplace in extensionsGallery on products.json (local user config)
    mkdir -p ~/.config/VSCodium/
    bash -c "echo -e '{\n  \"nameShort\": \"Visual Studio Code\",\n  \"nameLong\": \"Visual Studio Code\",\n  \"extensionsGallery\": {\n    \"serviceUrl\": \"https://marketplace.visualstudio.com/_apis/public/gallery\",\n    \"cacheUrl\": \"https://vscode.blob.core.windows.net/gallery/index\",\n    \"itemUrl\": \"https://marketplace.visualstudio.com/items\"\n  }\n}\n' > ~/.config/VSCodium/product.json"
    printf "${YELLOW}Installing vscodium MS marketplace ENV in /etc/profile.d/vscode-market.sh ...\n${NC}"
    sudo bash -c "echo -e 'export VSCODE_GALLERY_SERVICE_URL='https://marketplace.visualstudio.com/_apis/public/gallery'\nexport VSCODE_GALLERY_ITEM_URL='https://marketplace.visualstudio.com/items'\nexport VSCODE_GALLERY_CACHE_URL='https://vscode.blob.core.windows.net/gallery/index'\nexport VSCODE_GALLERY_CONTROL_URL=''' > /etc/profile.d/vscode-market.sh"
}
