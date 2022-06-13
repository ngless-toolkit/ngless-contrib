#!/usr/bin/env bash

echo "Preparing to run macrel get-smorfs"

# Abort on any errors from this point onwards
set -ve

MACREL=$(which macrel)

ARG_PARSE="getopt -o o: -l ofile: -n $0 --"

# We process arguments twice to handle any argument parsing error:
ARGS=$($ARG_PARSE "$@")
eval set -- "$ARGS"

while true; do
    echo "$1"
    case "$1" in
        -o|--ofile)
            shift
            OUTPUT_FNA="$1"
            shift
            ;;
        --)
            shift
            break
            ;;
    esac
done

INPUT_FNA="$1"

"$MACREL" \
    get-smorfs \
        -f "${INPUT_FNA}" \
        --file-output "${OUTPUT_FNA}" \
        --threads "$NGLESS_NR_CORES" \
        --keep-fasta-headers

