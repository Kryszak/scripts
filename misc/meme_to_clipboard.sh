#!/bin/bash

INPUT_IMAGE=$1
TOP_TEXT=$2
BOTTOM_TEXT=$3

MEME_PATH=${HOME}/meme.png

shitpost -f "${INPUT_IMAGE}" -t "${TOP_TEXT}" -b "${BOTTOM_TEXT}" -o $MEME_PATH

xclip -selection clipboard -t image/png -i $MEME_PATH

rm $MEME_PATH
