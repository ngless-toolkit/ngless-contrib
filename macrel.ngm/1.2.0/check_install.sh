#!/usr/bin/env bash

if ! which macrel;  then
    echo "Macrel not found!"
    exit 1
fi

exec macrel --version
