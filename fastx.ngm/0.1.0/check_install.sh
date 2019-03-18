#!/usr/bin/env bash

if ! command -v getopt >/dev/null ; then
    echo >&2 "getopt command not found"
    exit 1
fi

if ! command -v zcat >/dev/null ; then
    echo >&2 "zcat command not found"
    exit 1
fi

if ! command -v fastx_quality_stats >/dev/null ; then
    echo >&2 "fastx_quality_stats command not found"
    exit 1
fi

VERSION="$(fastx_quality_stats -h | grep FASTX | cut -d ' ' -f 5)"
# 0.0.14 is the latest release - a few extra bugfixes exist on https://github.com/agordon/fastx_toolkit
# We also use 0.0.14 because 0.0.13 defaulted to base 64 quality encoding
EXPECTED="0.0.14"

if [ "$EXPECTED" != "$VERSION" ]; then
    echo >&2 "Expected fastx_quality_stats version $EXPECTED but saw $VERSION"
    echo >&2 "NOTE: Versions  < 0.0.14 assume Illumina (base 64) quality encoding used in older technology."
    echo >&2 "      Versions >= 0.0.14 assume Sanger (base 33) quality encoding used by most modern platforms."
    exit 1
fi

echo "fastx_quality_stats is: $(which fastx_quality_stats)"
