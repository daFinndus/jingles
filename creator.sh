#!/bin/bash

# Please ignore this script.
# It was totally written by Claude, I didn't do anything.
# It was just to help me create entries faster.

RED="\033[38;2;220;50;50m"
YELLOW="\033[38;2;220;180;0m"
GREEN="\033[38;2;50;200;50m"
BLUE="\033[38;2;50;120;220m"
RESET="\033[0m"

log_step() { echo -e "\n${BLUE}[*]${RESET} $1"; }
log_success() { echo -e "${GREEN}[+]${RESET} $1"; }
log_warn() { echo -e "${YELLOW}[!]${RESET} $1"; }
log_error() { echo -e "${RED}[-]${RESET} $1"; }

FILE_PATH="$1"
GAME_NAME="$2"
PLATFORM="$3"
JSON_FILE="index.json"

if [[ -z "$FILE_PATH" || -z "$GAME_NAME" || -z "$PLATFORM" ]]; then
  log_error "Usage: jingle-add <path> <game name> <platform>"
  exit 1
fi

if [[ ! -f "$FILE_PATH" ]]; then
  log_error "File not found: $FILE_PATH"
  exit 1
fi

FILENAME=$(basename "$FILE_PATH")
JINGLE_PATH="jingles/$PLATFORM/$FILENAME"

log_step "Adding '$GAME_NAME' to '$PLATFORM'..."

PLATFORM_EXISTS=$(jq --arg p "$PLATFORM" 'has($p)' "$JSON_FILE")

if [[ "$PLATFORM_EXISTS" == "false" ]]; then
  log_warn "Platform '$PLATFORM' not found in JSON, creating it..."
  jq --arg p "$PLATFORM" --arg f "$JINGLE_PATH" --arg g "$GAME_NAME" \
    '.[$p] = [{"file": $f, "game": $g}]' \
    "$JSON_FILE" > /tmp/jingles_tmp.json && mv /tmp/jingles_tmp.json "$JSON_FILE"
else
  jq --arg p "$PLATFORM" --arg f "$JINGLE_PATH" --arg g "$GAME_NAME" \
    '.[$p] += [{"file": $f, "game": $g}]' \
    "$JSON_FILE" > /tmp/jingles_tmp.json && mv /tmp/jingles_tmp.json "$JSON_FILE"
fi

log_success "Done! Added '$GAME_NAME' → $JINGLE_PATH"
