#!/usr/bin/env bash

echo "Preparing to plot with fastqp"

# Parsing arguments passed
ARG_PARSE="getopt -o o:n:s:auc -l oprefix:,name:,sample_size:,aligned_only,unaligned_only,count_duplicates -n $0 --"

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
NAME=""
SAMPLESIZE=""
ALIGNED=""
UNALIGNED=""
DUPLICATES=""

while true; do
    case "$1" in
        # Shift before to throw away option
        # Shift after if option has a required positional argument
        -o|--oprefix)
            shift
            OUTPUT="$1"
            shift
            ;;
        -n|--name)
            shift
            NAME="--name $1"
            shift
            ;;
        -s|--sample_size)
            shift
            SAMPLESIZE="--nreads $1"
            shift
            ;;
        -a|--aligned_only)
            shift
            ALIGNED="--aligned-only"
            ;;
        -u|--unaligned_only)
            shift
            UNALIGNED="--unaligned-only"
            ;;
        -c|--count_duplicates)
            shift
            DUPLICATES="--count-duplicates"
            ;;
        --)
            shift
            break
            ;;
    esac
done

# fastqp accepts one input at a time so we need to create multiple outputs
INPUTS=()

if [[ ! -z "$1" ]] ; then
    INPUTS+=("$1")
    OUT=(single)
    if [[ ! -z "$2" ]] ; then
        INPUTS+=("$2")
        OUT=(pair.1 pair.2)
        if [[ ! -z "$3" ]] ; then
            INPUTS+=("$3")
            OUT=(pair.1 pair.2 single)
        fi
    fi
fi

SAMTOOLS="$($NGLESS_NGLESS_BIN --print-path samtools)"

# link binaries into PATH to force motus profiler to use them
TMPDIR="$(mktemp -d)"
if [ "${TMPDIR}x" = "x" ]; then
    echo "Failed to create temporary directory"
    exit 1
fi

TMPBINDIR="${TMPDIR}/bin"
mkdir -p "${TMPBINDIR}"
ln -s "$SAMTOOLS" "${TMPBINDIR}/samtools"

export PATH=$TMPBINDIR:$PATH

echo "Plotting..."
for i in "${!INPUTS[@]}"; do 
    "$NGLESS_MODULE_DIR/mc3/bin/fastqp" \
        --quiet \
        $NAME \
        $SAMPLESIZE \
        $ALIGNED \
        $UNALIGNED \
        $DUPLICATES \
        --output "${OUTPUT}_${OUT[$i]}" \
        "${INPUTS[$i]}"
done

rm -rf "${TMPDIR}"
