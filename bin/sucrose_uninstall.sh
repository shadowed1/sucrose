#!/bin/bash
# Sucrose Uninstaller

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

read -r -p "${RED}${BOLD}Remove Sucrose and its entry from ~/.bashrc? [y/N] ${RESET}" ans

if [[ "$ans" =~ ^[Yy]$ ]]; then
            echo "${RED}[*] Removing Sucrose...${RESET}"
            sudo rm /usr/local/bin/sucrose 2>/dev/null
            sudo rm /usr/local/bin/sucrose-daemon 2>/dev/null
            sudo rm /home/chronos/.sucrose.fifo 2>/dev/null
            sudo rm /home/chronos/.sucrose.fifo 2>/dev/null
            sudo rm /home/chronos/.sucrose.lock 2>/dev/null
            sudo rm /home/chronos/.sucrose.reply* 2>/dev/null
            CHROMEOS_BASHRC="/home/chronos/user/.bashrc"
            DEFAULT_BASHRC="$HOME/.bashrc"
            TARGET_FILE=""
        
            if [ -f "$CHROMEOS_BASHRC" ]; then
                TARGET_FILE="$CHROMEOS_BASHRC"
            elif [ -f "$DEFAULT_BASHRC" ]; then
                TARGET_FILE="$DEFAULT_BASHRC"
            fi
        
            if [ -n "$TARGET_FILE" ]; then
                sed -i '/^# <<< SUCROSE SUDO MARKER <<</,/^# <<< END SUCROSE SUDO MARKER <<</d' "$TARGET_FILE"
            else
                echo "${RED}No .bashrc found! ${RESET}"
            fi
            
        echo "${CYAN}[+] Uninstalled${RESET}"
else
        echo "${RED}[*] Cancelled ${RESET}"
fi

exit 0
