#!/bin/bash

# This script only exists because it's annoying me to do this manually.

BEFORE=$1
AFTER=$2

ffmpeg -i "$1" -vn -acodec copy -t 00:00:15 "$2"

rm "$1"
