#!/bin/bash
# Bidirectional Sucrose Wrapper
# shadowed1

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
BOLD=$(tput bold)
RESET=$(tput sgr0)

CMD_FIFO="/home/chronos/.sucrose.fifo"

if [[ ! -p "$CMD_FIFO" ]]; then
    echo 'sudo: The "no new privileges" flag is set, which prevents sudo from running as root.'
    echo "sudo: If sudo is running in a container, you may need to adjust the container configuration to disable the flag."
    echo "${RED}"
    echo "sucrose-daemon is not running - ${BOLD}sudo is disabled${RESET}"
    echo
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "usage: sudo -h | -K | -k | -V "
    echo "usage: sudo -v [-ABkNnS] [-g group] [-h host] [-p prompt] [-u user] "
    echo "usage: sudo -l [-ABkNnS] [-g group] [-h host] [-p prompt] [-U user] "
    echo "            [-u user] [command [arg ...]] "
    echo "usage: sudo [-ABbEHkNnPS] [-C num] [-D directory] "
    echo "            [-g group] [-h host] [-p prompt] [-R directory] [-T timeout] "
    echo "            [-u user] [VAR=value] [-i | -s] [command [arg ...]] "
    echo "usage: sudo -e [-ABkNnS] [-C num] [-D directory] "
    echo "            [-g group] [-h host] [-p prompt] [-R directory] [-T timeout] "
    echo "            [-u user] file ... "
    echo "${GREEN}"
    echo "sucrose-daemon is running - ${BOLD}sudo is enabled${RESET}"
    echo
    exit 1
fi

REPLY_FIFO="/home/chronos/.sucrose.reply.$$"

cleanup() {
    rm -f "$REPLY_FIFO"
    echo "${RED}Stopping sucrose-daemon ${RESET}"
}
trap cleanup EXIT

mkfifo "$REPLY_FIFO"
chmod 600 "$REPLY_FIFO"

{
    printf '%s|' "$REPLY_FIFO"
    printf '%q ' "$@" | sed 's/ $/\n/'
} >"$CMD_FIFO"

exit_code=0

while IFS= read -r line; do
    if [[ "$line" == __SUCROS_EXIT__:* ]]; then
        exit_code="${line#__SUCROS_EXIT__:}"
    else
        echo "$line"
    fi
done <"$REPLY_FIFO"

exit "$exit_code"
