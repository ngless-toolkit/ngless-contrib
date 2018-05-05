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

if ! command -v cut >/dev/null ; then
    echo "cut command not found"
    exit 1
fi

if ! command -v flock >/dev/null ; then
    echo "flock command not found"
    exit 1
fi

SALMONDIR="$NGLESS_MODULE_DIR/Salmon-latest_linux_x86_64"

if [ ! -d "$SALMONDIR" ]; then
    echo "Salmon is not installed. Please run the following command to install:"
    echo "  cd $(pwd)/$NGLESS_MODULE_DIR && wget https://github.com/COMBINE-lab/salmon/releases/download/v0.9.1/Salmon-0.9.1_linux_x86_64.tar.gz && tar xf Salmon-0.9.1_linux_x86_64.tar.gz"
    exit 1
fi
