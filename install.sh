#!/usr/bin/env bash

# Chdir to the current's script location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1

INSTALLDIR="$HOME/.local/share/ngless/data/Modules"

# Check that the user's ngless config dir exists
mkdir -p "$INSTALLDIR"

for mod in *.ngm; do
    if [ ! -e "${INSTALLDIR}/$mod" ]; then
        mkdir "${INSTALLDIR}/$mod"
    fi
    for version in ${mod}/* ; do
        if [ ! -d "$version" ]; then
            continue
        fi
        if [ -e "${INSTALLDIR}/${version}" ]; then
            if [ -L "${INSTALLDIR}/${version}" ]; then
                rm -f "${INSTALLDIR}/${version}"
            else
                echo "${INSTALLDIR}/${version} exists and is not a symlink. Please inspect and remove the folder manually. Skipping..." 
                continue
            fi
        fi
        echo "Installing ${version}" 
        ln -s "$(pwd)/${version}" "${INSTALLDIR}/${version}" 
    done
done
