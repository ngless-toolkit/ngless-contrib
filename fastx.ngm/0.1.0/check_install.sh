#!/usr/bin/env bash

if ! which getopt >/dev/null ; then
    echo "getopt command not found"
    exit 1
fi

if ! which fastx_quality_stats >/dev/null ; then
    echo "fastx_quality_stats command not found"
    exit 1
fi

echo "fastx_quality_stats is: $(which fastx_quality_stats)"
