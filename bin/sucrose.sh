#!/bin/bash
# Bidirectional Sucrose Wrapper
# shadowed1

CMD_FIFO="/home/chronos/.sucrose.fifo"

if [[ ! -p "$CMD_FIFO" ]]; then
    echo "sucrose-daemon not running" >&2
    echo "Open VT-2 (ctrl-alt-refresh), log in as chronos, and run: "
    echo
    echo "sudo sucrose-daemon"
    echo
    echo "ctrl-alt-back to return. Sudo should now function."
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
    exit 1
fi

REPLY_FIFO="/home/chronos/.sucrose.reply.$$"

cleanup() {
    rm -f "$REPLY_FIFO"
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
