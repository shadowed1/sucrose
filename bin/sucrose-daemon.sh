#!/bin/bash
# Sucrose Daemon
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
LOCK_FILE="/home/chronos/.sucrose.lock"

exec 200>"$LOCK_FILE" || exit 1
flock -n 200 || {
    echo
    echo "[sucrose-daemon] Already running"
    echo
    exit 1
}

rm -f "$CMD_FIFO" 2>/dev/null
mkfifo "$CMD_FIFO"
chown 1000:1000 "$CMD_FIFO"
chmod 600 "$CMD_FIFO"

echo
echo "[sucrose-daemon] Listening on $CMD_FIFO"
echo

while true; do
    if IFS= read -r line <"$CMD_FIFO"; then
        reply_fifo="${line%%|*}"
        cmd="${line#*|}"
        cmd="${cmd#"${cmd%%[![:space:]]*}"}"
        cmd="${cmd%"${cmd##*[![:space:]]}"}"

        [[ -z "$cmd" ]] && continue
        [[ ! -p "$reply_fifo" ]] && continue

        echo "[sucrose-daemon] Running: $cmd" >/dev/tty

        {
            /bin/bash -c "$cmd"
        } 2>&1 | tee /dev/tty >"$reply_fifo"
    fi
done
