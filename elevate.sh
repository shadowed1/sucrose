#!/bin/bash
# ChromeOS Elevated Shell
# shadowed1

FIFO="/home/chronos/.elevate.fifo"

if [[ ! -p "$FIFO" ]]; then
    echo "elevate: daemon not running" >&2
    exit 1
fi

if [[ $# -eq 0 ]]; then
    echo "usage: elevate <command...>" >&2
    exit 1
fi

printf '%q ' "$@" | sed 's/ $/\n/' >"$FIFO"
