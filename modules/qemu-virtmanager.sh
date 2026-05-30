#!/usr/bin/env bash
# Module: qemu-virtmanager
# DESC: QEMU and Virt-Manager
# DEFAULT: off
# ORDER: 441
# Called by install-packages.sh orchestrator

install_qemu_virtmanager() {
    printf "${YELLOW}Installing QEMU and Virt-Manager...\n${NC}"
    # Step 1: Install the Packages
    # Note: edk2-ovmf is required for UEFI support in VMs, and dnsmasq/iptables-nft are needed for default NAT networking.
    printf "${CYAN}Updating package lists and installing packages...\n${NC}"
    sudo pacman -Syu virt-manager qemu-desktop libvirt edk2-ovmf dnsmasq iptables-nft
    
    # Step 2: Enable and Start the Service
    printf "${CYAN}Enabling and starting libvirtd service...\n${NC}"
    sudo systemctl enable --now libvirtd

    # Step 3: Configure User Permissions
    printf "${CYAN}Configuring user (${CURRENT_USER}) permissions...\n${NC}"
    sudo usermod -aG libvirt $CURRENT_USER

    # Step 4: Configure the libvirt Daemon (Arch Specific) and restart service
    # Arch requires you to tell libvirt to trust the libvirt user group.
    # sudo nano /etc/libvirt/libvirtd.conf
    # unix_sock_group = "libvirt"
    # unix_sock_rw_perms = "0770"
 
    # Add unix_sock_group and unix_sock_rw_perms to libvirtd.conf if they are not already set
    if ! grep -q "unix_sock_group = \"libvirt\"" /etc/libvirt/libvirtd.conf; then
        echo 'unix_sock_group = "libvirt"' | sudo tee -a /etc/libvirt/libvirtd.conf
    fi
    if ! grep -q "unix_sock_rw_perms = \"0770\"" /etc/libvirt/libvirtd.conf; then
        echo 'unix_sock_rw_perms = "0770"' | sudo tee -a /etc/libvirt/libvirtd.conf
    fi  
    sudo systemctl restart libvirtd

    printf "${LCYAN}--------------------------------------------------------------------------------\n${GREEN}"
    printf "QEMU and Virt-Manager installation complete. Please log out and log back in for the group changes to take effect.\n"
    printf "${LCYAN}--------------------------------------------------------------------------------\n${NC}"
}
