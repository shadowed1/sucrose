#!/bin/bash
# Sucrose Installer
# shadowed1

set -e
echo "[sucrose] Installing..."
BIN_DIR="/usr/local/bin"
INIT_DIR="/etc/init"
mkdir -p "$BIN_DIR"

curl -fsSL https://raw.githubusercontent.com/shadowed1/sucrose/main/bin/sucrose.sh -o "$BIN_DIR/sucrose"
curl -fsSL https://raw.githubusercontent.com/shadowed1/sucrose/main/bin/sucrose-daemon.sh -o "$BIN_DIR/sucrose-daemon"
curl -fsSL https://raw.githubusercontent.com/shadowed1/sucrose/main/bin/sucrose_uninstaller.sh -o "$BIN_DIR/sucrose_uninstaller"
sudo chmod +x "$BIN_DIR/sucrose"
sudo chmod +x "$BIN_DIR/sucrose-daemon"
sudo chmod +x "$BIN_DIR/sucrose_uninstaller"

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
    echo "    alias sudo='sucrose'"
    echo 'else'
    echo '    unalias sudo 2>/dev/null'
    echo 'fi'
    echo "# <<< END SUCROSE SUDO MARKER <<<"
} >> "$TARGET_FILE"
echo "${RESET}${GREEN}"
echo "[sucrose] Installation complete"
echo ${RESET}${BLUE}
echo "${RESET}"

read -r -p "${BLUE}${BOLD}Start sucros-daemon now? [y/N] ${RESET}" ans

if [[ "$ans" =~ ^[Yy]$ ]]; then
        echo "${BLUE}Running: sudo sucrose-daemon 2>/dev/null & ${RESET}"
        sudo sucros-daemon 2>/dev/null &
else
        echo "${BLUE}Run: sudo sucrose-daemon in VT-2 logged in as chronos when ready ${RESET}"
fi
