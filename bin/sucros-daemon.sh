#!/bin/bash
# Sucros Daemon
# shadowed1

CMD_FIFO="/home/chronos/.sucros.fifo"
LOCK_FILE="/home/chronos/.sucros.lock"

exec 200>"$LOCK_FILE" || exit 1
flock -n 200 || {
    echo
    echo "[sucros-daemon] Already running"
    echo
    exit 1
}

rm -f "$CMD_FIFO" 2>/dev/null
mkfifo "$CMD_FIFO"
chown 1000:1000 "$CMD_FIFO"
chmod 600 "$CMD_FIFO"

echo
echo "[sucros-daemon] Listening on $CMD_FIFO"
echo

while true; do
    if IFS= read -r line <"$CMD_FIFO"; then
        reply_fifo="${line%%|*}"
        cmd="${line#*|}"
        cmd="${cmd#"${cmd%%[![:space:]]*}"}"
        cmd="${cmd%"${cmd##*[![:space:]]}"}"

        [[ -z "$cmd" ]] && continue
        [[ ! -p "$reply_fifo" ]] && continue

        echo "[sucros-daemon] Running: $cmd" >/dev/tty

        {
            /bin/bash -c "$cmd"
        } 2>&1 | tee /dev/tty >"$reply_fifo"
    fi
done
