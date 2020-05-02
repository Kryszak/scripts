#!/bin/bash

# Get sum of hours from last 5 days

last | grep $USER | tail -n +2 | head -n 5 | tr -s " " | awk '{print $9}' | tr -d '()' | awk -F ':' '{hours+=$1; minutes+=$2} END {time=hours+minutes/60; print time "h"}'
