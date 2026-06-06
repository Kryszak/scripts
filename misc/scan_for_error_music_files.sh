#!/bin/bash

dir="$1"

for f in $(find "$dir" -type f); do
  ffprobe -v error "$f" >/dev/null 2>&1 || echo "$f"
done
