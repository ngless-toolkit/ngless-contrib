#!/usr/bin/env bash

# Parsing arguments passed
ARG_PARSE="getopt -o o: -l oprefix: -n $0 --"

# We process arguments twice to handle any argument parsing error:
ARG_ERROR=$($ARG_PARSE "$@" 2>&1 1>/dev/null)

if [ $? -ne 0 ]; then
    echo >&2 "${ERROR} $ARG_ERROR"
    echo >&2 ""
    exit 1
fi

# Abort on any errors from this point onwards
set -e

# Parse args using getopt (instead of getopts) to allow arguments before options
ARGS=$($ARG_PARSE "$@")

# reorganize arguments as returned by getopt
eval set -- "$ARGS"

# Initialize default values
OUTPUT=""

while true; do
    case "$1" in
        # Shift before to throw away option
        # Shift after if option has a required positional argument
        -o|--oprefix)
            shift
            OUTPUT="$1"
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done

echo >&2 "Arguments are: $*"

# forward, reverse and single reads
if [[ "1" -eq "$#" ]] ; then
    fastx_quality_stats -i <(zcat "$1") -o "${OUTPUT}.fxstats"
elif [[ "2" -eq "$#" ]]; then
    fastx_quality_stats -i <(zcat "$1") -o "${OUTPUT}.pair.1.fxstats"
    fastx_quality_stats -i <(zcat "$2") -o "${OUTPUT}.pair.2.fxstats"
elif [[ "3" -eq "$#" ]]; then
    fastx_quality_stats -i <(zcat "$1") -o "${OUTPUT}.pair.1.fxstats"
    fastx_quality_stats -i <(zcat "$2") -o "${OUTPUT}.pair.2.fxstats"
    fastx_quality_stats -i <(zcat "$3") -o "${OUTPUT}.single.fxstats"
else
    echo >&2 "ERROR: Invalid number of files (arguments) passed."
    echo >&2 "  Expected: 1 (single), 2 (pair.1 + pair.2) or 3 (pairs + single)"
    echo >&2 "  Saw: $#"
    exit 1
fi
