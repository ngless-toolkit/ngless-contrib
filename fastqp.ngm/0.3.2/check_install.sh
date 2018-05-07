#!/usr/bin/env bash

if ! command -v mktemp >/dev/null ; then
    echo "mktemp command not found"
    exit 1
fi

if ! command -v getopt >/dev/null ; then
    echo "getopt command not found"
    exit 1
fi

if ! command -v sed >/dev/null ; then
    echo "sed command not found"
    exit 1
fi

FASTQP="$NGLESS_MODULE_DIR/mc3/bin/fastqp"

if [ ! -e "$FASTQP" ]; then
    echo "fastqp is not installed. Please run the following command to install:"
    echo "  cd $(pwd)/$NGLESS_MODULE_DIR && ./setup.sh"
    exit 1
fi
