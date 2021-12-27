#!/bin/bash

INPUT_IMAGE=$1
INPUT_TEXT=$2

MEME_PATH=$(meme -i "${INPUT_IMAGE}" -t "${INPUT_TEXT}")

xclip -selection clipboard -t image/png -i $MEME_PATH
