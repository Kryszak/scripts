#!/bin/bash

PASS=$1

shift 1

for position in "$@"; do
    echo "$PASS" | cut -c $position
done
