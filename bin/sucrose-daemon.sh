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
AUTH_FILE="/home/chronos/.sucrose.auth"
exec 200>"$LOCK_FILE" || exit 1
flock -n 200 || {
    echo
    echo "[sucrose-daemon] Already running"
    echo
    exit 1
}
if [[ ! -f "$AUTH_FILE" ]]; then
    head -c 32 /dev/urandom | base64 | tr -d '/+=' | head -c 43 > "$AUTH_FILE"
    chmod 400 "$AUTH_FILE"
    chown 1000:1000 "$AUTH_FILE"
    echo "${GREEN}[sucrose-daemon] Generated new authentication token ${RESET}"
fi
AUTH_TOKEN=$(cat "$AUTH_FILE")
rm -f "$CMD_FIFO" 2>/dev/null
mkfifo "$CMD_FIFO"
chown 1000:1000 "$CMD_FIFO"
chmod 600 "$CMD_FIFO"

handle_command() {
    local token="$1"
    local reply_fifo="$2"
    local tty_dev="$3"
    local cmd="$4"
    
    if [[ "$token" != "$AUTH_TOKEN" ]]; then
        echo "[sucrose-daemon] Authentication failed" >/dev/tty
        {
            echo "${RED}Authentication failed${RESET}"
            echo "__SUCROSE_EXIT__:1"
        } >"$reply_fifo" 2>/dev/null
        return
    fi
    
    echo "[sucrose-daemon] Running: $cmd" >/dev/tty
    
    {
        /bin/bash -c "source ~/.bashrc 2>/dev/null; $cmd" <"$tty_dev" >"$tty_dev" 2>&1
        exit_code=$?
        echo "__SUCROSE_EXIT__:$exit_code"
    } >"$reply_fifo" &
}

cleanup() {
    jobs -p | xargs -r kill 2>/dev/null
    wait
    rm -f "$CMD_FIFO" 2>/dev/null
    sudo rm -f "$AUTH_FILE" 2>/dev/null
    echo "${RED}sucrose-daemon stopped${RESET}"
}

trap cleanup EXIT
trap 'exit' SIGINT SIGTERM

echo
echo "${GREEN}[sucrose-daemon] Listening on $CMD_FIFO"
echo "[sucrose-daemon] Authentication enabled ${RESET}"
echo

while true; do
    if IFS= read -r line <"$CMD_FIFO"; then
        token="${line%%|*}"
        rest="${line#*|}"
        reply_fifo="${rest%%|*}"
        rest="${rest#*|}"
        tty_dev="${rest%%|*}"
        cmd="${rest#*|}"
        cmd="${cmd#"${cmd%%[![:space:]]*}"}"
        cmd="${cmd%"${cmd##*[![:space:]]}"}"
        [[ -z "$cmd" ]] && continue
        [[ ! -p "$reply_fifo" ]] && continue
        handle_command "$token" "$reply_fifo" "$tty_dev" "$cmd"
    fi
done
