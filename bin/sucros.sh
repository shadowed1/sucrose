#!/bin/bash
# Bidirectional Sucros Wrapper
# shadowed1

CMD_FIFO="/home/chronos/.sucros.fifo"

if [[ ! -p "$CMD_FIFO" ]]; then
    echo "sucros-daemon not running" >&2
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "usage: sucros command" >&2
    exit 1
fi

REPLY_FIFO="/home/chronos/.sucros.reply.$$"

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
