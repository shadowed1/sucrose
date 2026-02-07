#!/bin/bash
# Sucrose Installer
# shadowed1

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

set -e
echo
echo "${MAGENTA}Noexec warning can be safely ignored.${RESET}"
echo
echo "${GREEN}[sucrose] Installing... ${RESET}"
BIN_DIR="/usr/local/bin"
INIT_DIR="/etc/init"
mkdir -p "$BIN_DIR"

curl -fsSL https://raw.githubusercontent.com/shadowed1/Sucrose/main/bin/sucrose.sh -o "$BIN_DIR/sucrose"
curl -fsSL https://raw.githubusercontent.com/shadowed1/Sucrose/main/bin/sucrose-daemon.sh -o "$BIN_DIR/sucrose-daemon"
curl -fsSL https://raw.githubusercontent.com/shadowed1/Sucrose/main/bin/sucrose-daemon.sh -o "$BIN_DIR/s-d"
curl -fsSL https://raw.githubusercontent.com/shadowed1/Sucrose/main/bin/sucrose_reinstall.sh -o "$BIN_DIR/sucrose_reinstall"
curl -fsSL https://raw.githubusercontent.com/shadowed1/Sucrose/main/bin/sucrose_uninstall.sh -o "$BIN_DIR/sucrose_uninstall"
sudo chmod +x "$BIN_DIR/sucrose"
sudo chmod +x "$BIN_DIR/sucrose-daemon"
sudo chmod +x "$BIN_DIR/s-d"
sudo chmod +x "$BIN_DIR/sucrose_uninstall"

CHROMEOS_BASHRC="/home/chronos/user/.bashrc"
DEFAULT_BASHRC="$HOME/.bashrc"
TARGET_FILE=""
        
if [ -f "$CHROMEOS_BASHRC" ]; then
    TARGET_FILE="$CHROMEOS_BASHRC"
elif [ -f "$DEFAULT_BASHRC" ]; then
    TARGET_FILE="$DEFAULT_BASHRC"
fi

sed -i '/^# <<< SUCROSE SUDO MARKER <<</,/^# <<< END SUCROSE SUDO MARKER <<</d' "$TARGET_FILE"

{
    echo "# <<< SUCROSE SUDO MARKER <<<"
    echo '# Auto-alias sudo to sucrose tester'
    echo 'sudo_output=$(sudo --version 2>&1 | head -n1)'
    echo 'if [[ "$sudo_output" == "sudo: The \"no new privileges\""* ]]; then'
    echo "    alias sudo='sucrose /usr/bin/sudo -E'"
    echo 'else'
    echo '    unalias sudo 2>/dev/null'
    echo 'fi'
    echo "# <<< END SUCROSE SUDO MARKER <<<"
} >> "$TARGET_FILE"
echo "${RESET}${GREEN}${BOLD}"
echo "[sucrose] Installation complete"
echo
echo "${RESET}"

read -r -p "${BLUE}${BOLD}Start sucros-daemon now? [y/N] ${RESET}" ans

if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo "${BLUE}Running: sudo sucrose-daemon${RESET}"
        sudo sucrose-daemon
else
        echo "${CYAN}Run: sudo sucrose-daemon in VT-2 logged in as chronos when ready ${RESET}"
fi

sudo rm /home/chronos/user/sucrose_installer 2>/dev/null
