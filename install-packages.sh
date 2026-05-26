#!/bin/bash
CURRENT_USER=$(whoami)

# Detect if running from a local clone or via pipe (curl | bash)
if [[ -n "${BASH_SOURCE[0]:-}" && -f "${BASH_SOURCE[0]}" ]]; then
    SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
else
    # Running via pipe: no local files available
    SCRIPT_DIR="$(mktemp -d /tmp/arch-post-install.XXXXXX)"
    REMOTE_BRANCH="${ARCH_BRANCH:-main}"
    REMOTE_BASE="https://raw.githubusercontent.com/AlessandroPerazzetta/arch-post-install/${REMOTE_BRANCH}"
    REMOTE_API_BASE="https://api.github.com/repos/AlessandroPerazzetta/arch-post-install"
    _remote_mode=true
fi
LIB_DIR="${SCRIPT_DIR}/lib"
MODULES_DIR="${SCRIPT_DIR}/modules"

# Early remote block: fetch lib files before sourcing
if [[ "${_remote_mode:-false}" == "true" ]]; then
    mkdir -p "${LIB_DIR}" "${MODULES_DIR}"
    for f in colors.sh helpers.sh; do
        curl -fsSLo "${LIB_DIR}/${f}" "${REMOTE_BASE}/lib/${f}"
    done
fi

# shellcheck source=lib/colors.sh
source "${LIB_DIR}/colors.sh"
# shellcheck source=lib/helpers.sh
source "${LIB_DIR}/helpers.sh"

printf "${YELLOW}------------------------------------------------------------------\n${NC}"
printf "${YELLOW}Starting ...\n${NC}"
printf "${YELLOW}------------------------------------------------------------------\n${NC}"

if [ "$EUID" -eq 0 ]; then
    printf "${LRED}Do not run this script as root. Please run as a regular user.${NC}\n"
    exit 1
fi

printf "${YELLOW}Updating system...\n${NC}"
sleep 1
sudo pacman -Sy

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1
sudo pacman -Syyu --noconfirm

printf "${YELLOW}Install required packages...\n${NC}"
sleep 1

# Entries can be "package" (binary==package) or "binary:package" when they differ
commands_to_check_exist=("curl" "wget" "git" "jq" "pigz" "pbzip2" "pxz" "zip" "unzip" "ssh:openssh" "rg:ripgrep" "bat" "ifconfig:net-tools" "hostname:inetutils")
for entry in "${commands_to_check_exist[@]}"; do
    if [[ "$entry" == *:* ]]; then
        cmd="${entry%%:*}"
        pkg="${entry##*:}"
    else
        cmd="$entry"
        pkg="$entry"
    fi
    if command_exists "$cmd"; then
        printf "${LGREEN}Command ${pkg} is already installed.\n${NC}"
    else
        printf "${LCYAN}Command ${pkg} not found. Installing... \n${NC}"
        sudo pacman -Sy "$pkg" --noconfirm
        printf "\n${NC}"
    fi
done

# Install base-devel if not already installed
if ! pacman -Qi base-devel &>/dev/null; then
    printf "${YELLOW}Installing base-devel...\n${NC}"
    sudo pacman -Sy --needed base-devel --noconfirm
else
    printf "${LGREEN}base-devel is already installed.\n${NC}"
fi

if command -v sshd &> /dev/null; then
    printf "${YELLOW}Openssh found. Checking systemd service...\n${NC}"
    if ! systemctl is-enabled --quiet sshd; then
        printf "${YELLOW}Enabling and starting sshd service...\n${NC}"
        sudo systemctl enable sshd
        sudo systemctl start sshd
    else
        printf "${LGREEN}sshd service is already enabled.\n${NC}"
    fi
fi

if ! command -v yay &> /dev/null
then
    # printf "${YELLOW}Install AUR packages...\n${NC}"
    # sleep 1
    # git clone https://aur.archlinux.org/yay-bin.git
    # cd yay-bin
    # makepkg -si
    # yay -Syu

    printf "${YELLOW}Install yay git package from AUR...\n${NC}"
    cd /tmp/
    if [ -d yay ]; then
        printf "${YELLOW}yay directory already exists, delete before git clone...\n${NC}"
        rm -rf yay
    fi
    git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si --noconfirm && yay -Syu
    cd -
fi

sleep 1

# Remote module discovery — deferred until curl, jq and yay are guaranteed available
if [[ "${_remote_mode:-false}" == "true" ]]; then
    printf "${YELLOW}Fetching module list from remote...\n${NC}"
    _api_url="${REMOTE_API_BASE}/contents/modules?ref=${REMOTE_BRANCH}"
    _module_keys="$(curl -fsSL "${_api_url}" \
        | jq -r '.[] | select(.name | endswith(".sh")) | .name[:-3]')"
    if [[ -z "$_module_keys" ]]; then
        printf "${RED}ERROR: Failed to fetch module list from %s\n${NC}" "${_api_url}" >&2
        exit 1
    fi
    _total_modules=$(wc -l <<< "$_module_keys")
    _current_module=0
    printf "${YELLOW}Downloading %d modules...\n${NC}" "${_total_modules}"
    while IFS= read -r key; do
        _current_module=$(( _current_module + 1 ))
        printf "${LCYAN}[%d/%d] Downloading module: %s\n${NC}" "${_current_module}" "${_total_modules}" "${key}"
        curl -fsSLo "${MODULES_DIR}/${key}.sh" "${REMOTE_BASE}/modules/${key}.sh"
    done <<< "$_module_keys"
    printf "${LGREEN}All modules downloaded.\n${NC}"
fi

read dialog <<< "$(which whiptail dialog 2> /dev/null)"
[[ "$dialog" ]] || {
    printf "${LRED}Neither whiptail nor dialog found\n${NC}"
    printf "${YELLOW}Consider installing whiptail with:\n${NC}"
    printf "${ORANGE}pacman -S libnewt\n${NC}"
    exit 1
}

# Build ALL_OPTIONS dynamically from module metadata (# DESC / # DEFAULT / # ORDER / # REQUIRE headers)
ALL_OPTIONS=()
declare -A _mod_order=()
declare -A _mod_require=()
_opts_unsorted=()
for _mod_file in "${MODULES_DIR}"/*.sh; do
    [[ -f "$_mod_file" ]] || continue
    _key="$(basename "${_mod_file}" .sh)"
    _desc="$(grep -m1 '^# DESC:' "${_mod_file}" | sed 's/^# DESC:[[:space:]]*//')"
    _default="$(grep -m1 '^# DEFAULT:' "${_mod_file}" | sed 's/^# DEFAULT:[[:space:]]*//')"
    _order="$(grep -m1 '^# ORDER:' "${_mod_file}" | sed 's/^# ORDER:[[:space:]]*//')"
    _require="$(grep -m1 '^# REQUIRE:' "${_mod_file}" | sed 's/^# REQUIRE:[[:space:]]*//')"
    [[ -z "$_desc" ]] && _desc="$_key"
    [[ "$_default" != "on" && "$_default" != "off" ]] && _default="off"
    [[ "$_order" =~ ^[0-9]+$ ]] || _order="999"
    _opts_unsorted+=("${_order}|${_key}|${_desc}|${_default}")
    _mod_order["$_key"]="$_order"
    _mod_require["$_key"]="$_require"
done

# Sort menu entries by ORDER so the checklist reflects installation sequence
while IFS= read -r _line; do
    ALL_OPTIONS+=("${_line#*|}")
done < <(printf '%s\n' "${_opts_unsorted[@]}" | sort -t'|' -k1,1n)

# Parse arguments
ALL_OFF=false
for arg in "$@"; do
    [[ "$arg" == "--none" ]] && ALL_OFF=true
done

# Build options array for dialog/whiptail
options=()
for opt in "${ALL_OPTIONS[@]}"; do
    IFS='|' read -r key desc def <<< "$opt"
    if $ALL_OFF; then
        options+=("$key" "$desc" "off")
    else
        options+=("$key" "$desc" "$def")
    fi
done

cmd=("$dialog" --title "Automated packages installation" --backtitle "Arch Post Install" --separate-output --checklist "Select options:" 22 76 16)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear

if [ ${#choices} -gt 0 ]; then
    # Build a set of selected keys
    declare -A _selected=()
    for choice in $choices; do
        _selected["$choice"]=1
    done

    # Auto-include any REQUIRE dependencies not explicitly selected
    _changed=true
    while $_changed; do
        _changed=false
        for _key in "${!_selected[@]}"; do
            for _dep in ${_mod_require[$_key]:-}; do
                if [[ -z "${_selected[$_dep]:-}" ]]; then
                    printf "${YELLOW}Auto-including '${_dep}' required by '${_key}'.\n${NC}"
                    _selected["$_dep"]=1
                    _changed=true
                fi
            done
        done
    done

    # Sort selected keys by # ORDER value, then execute
    while IFS=' ' read -r _order _key; do
        module_file="${MODULES_DIR}/${_key}.sh"
        if [[ -f "${module_file}" ]]; then
            # shellcheck source=/dev/null
            source "${module_file}"
            fn_name="install_${_key//-/_}"
            if declare -f "${fn_name}" > /dev/null; then
                "${fn_name}"
            else
                printf "${RED}Module ${_key}: function ${fn_name} not found.\n${NC}"
            fi
        else
            printf "${RED}Module not found: ${module_file}\n${NC}"
        fi
    done < <(
        for _key in "${!_selected[@]}"; do
            printf '%s %s\n' "${_mod_order[$_key]:-999}" "$_key"
        done | sort -n
    )
else
    exit 0
fi
