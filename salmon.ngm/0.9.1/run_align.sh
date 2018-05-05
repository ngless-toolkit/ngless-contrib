#!/usr/bin/env bash

echo "Preparing to run salmon"

# Parsing arguments passed
ARG_PARSE="getopt -o t:l:o:dsm -l transcripts:,libtype:,ofile:,seq_bias,meta -n $0 --"

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
DB=""
LIBTYPE=""
OUTPUT=""
SEQBIAS=""
META=""

SALMON="$NGLESS_MODULE_DIR/Salmon-latest_linux_x86_64/bin/salmon"

while true; do
    case "$1" in
        # Shift before to throw away option
        # Shift after if option has a required positional argument
        -t|--transcripts)
            shift
            DB="$1"
            shift
            ;;
        -l|--libtype)
            shift
            LIBTYPE="$1"
            shift
            ;;
        -o|--ofile)
            shift
            OUTPUT="$1"
            shift
            ;;
        -s|--seq_bias)
            shift
            SEQBIAS="--seqBias"
            ;;
        -m|--meta)
            shift
            META="--meta"
            ;;
        --)
            shift
            break
            ;;
    esac
done

# SAM/BAM file
BAM="$1"

TMPDIR="$(mktemp -d)"
if [ "${TMPDIR}x" = "x" ]; then
    echo "Failed to create temporary directory"
    exit 1
fi
TMPOUTPUT="${TMPDIR}/result"

echo "Quantifying..."
"$SALMON" quant \
    --libType "${LIBTYPE}" \
    --alignments "${BAM}" \
    --targets "${DB}" \
    --threads "$NGLESS_NR_CORES" \
    "${META}" \
    "${SEQBIAS}" \
    --output "${TMPOUTPUT}"

# Target output
echo "Formatting output to match NGLess expectation"
cut -f 1,5 "${TMPOUTPUT}/quant.sf" > "${OUTPUT}"

rm -rf "${TMPDIR}"
