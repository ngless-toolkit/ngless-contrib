#!/usr/bin/env bash

if ! which python >/dev/null ; then
    echo "python command not found"
    exit 1
fi

if ! which getopt >/dev/null ; then
    echo "getopt command not found"
    exit 1
fi

if ! which sed >/dev/null ; then
    echo "sed command not found"
    exit 1
fi

if ! which cat >/dev/null ; then
    echo "cat command not found"
    exit 1
fi

if ! which cut >/dev/null ; then
    echo "cut command not found"
    exit 1
fi

if ! which sort >/dev/null ; then
    echo "sort command not found"
    exit 1
fi

if ! python -c 'import sys; not ((sys.version_info.major == 2 and sys.version_info.minor >= 7) or sys.version_info.major == 3) and sys.exit(1)' >/dev/null ; then
    echo "Incompatible python version: need 2.7 or 3.x"
    exit 1
fi

if [[ ! -z "$1" ]] ; then
    # Parsing arguments passed
    ARG_PARSE="getopt -o veabo:t:A: -l ignore_viruses,ignore_eukaryotes,ignore_archaea,ignore_bacteria,ofile:,taxonomic_level:,analysis_type: -n $0 --"

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
    IGNORES=""
    OUTPUT=""
    TAXLEVEL=""
    ANALYTYPE=""

    while true; do
        case "$1" in
            # Shift before to throw away option
            # Shift after if option has a required positional argument
            -v|--ignore_viruses)
                shift
                IGNORES="$IGNORES --ignore_viruses"
                ;;
            -e|--ignore_eukaryotes)
                shift
                IGNORES="$IGNORES --ignore_eukaryotes"
                ;;
            -a|--ignore_archaea)
                shift
                IGNORES="$IGNORES --ignore_archaea"
                ;;
            -b|--ignore_bacteria)
                shift
                IGNORES="$IGNORES --ignore_bacteria"
                ;;
            -o|--ofile)
                shift
                OUTPUT="$1"
                shift
                ;;
            -t|--taxonomic_level)
                shift
                TAXLEVEL="$1"
                shift
                ;;
            -A|--analysis_type)
                shift
                ANALYTYPE="$1"
                shift
                ;;
            --)
                shift
                break
                ;;
        esac
    done

    # forward, reverse and single reads
    if [[ ! -z "$1" ]] ; then
        READS="$1"
        if [[ ! -z "$2" ]] ; then
            READS="$READS $2"
            if [[ ! -z "$3" ]] ; then
                READS="$READS $3"
            fi
        fi
    fi

    # Load metaphlan2 Bork setup
    if [ -f /etc/profile.d/modules.sh ] ; then
        source /etc/profile.d/modules.sh
    fi
    module add metaphlan2/2.7.0-2cd058a685f2

    set -euo pipefail

    cat ${READS} | metaphlan2.py \
        --input_type fastq \
        -t "${ANALYTYPE}" \
        ${IGNORES} \
        --nproc "$NGLESS_NR_CORES" \
        --tax_lev "${TAXLEVEL}" \
        --sample_id_key '#' \
        --no_map \
        | sed '/^\#/d' | sort > "${OUTPUT}"
    # metaphlan's output isn't exactly compatible with ngless' collect() function
    # Removing comments (sed) and sorting (sort) the output alphabetically makes it compatible
fi
