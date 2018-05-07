#! /usr/bin/env bash

# Abort on any errors
set -e

# Chdir to the current's script location
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1

# Miniconda install directory
MC="./mc3"

# Install miniconda3
wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
sh Miniconda3-latest-Linux-x86_64.sh -b -p "${MC}"
rm -f Miniconda3-latest-Linux-x86_64.sh

# Install dependencies
"${MC}/bin/conda" install scipy numpy matplotlib==2.1 -y

# and finally fastqp
"${MC}/bin/pip" install fastqp==0.3.2
