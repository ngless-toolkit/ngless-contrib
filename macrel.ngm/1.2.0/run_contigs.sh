#!/usr/bin/env bash

echo "Preparing to run macrel run-contigs"

# Abort on any errors from this point onwards
set -ve

MACREL=$(which macrel)

ARG_PARSE="getopt -o o: -l output: -n $0 --"

# We process arguments twice to handle any argument parsing error:
ARGS=$($ARG_PARSE "$@")
eval set -- "$ARGS"

while true; do
    echo "$1"
    case "$1" in
        -o|--output)
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

INPUT_FNA="$1"

"$MACREL" \
    contigs \
        -f "${INPUT_FNA}" \
        --output ${OUTPUT} \
        --threads "$NGLESS_NR_CORES" \
        --keep-fasta-headers

