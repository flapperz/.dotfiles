#!/bin/bash

THRESHOLD=5 # percent
MAXOPT=$([ $1 -lt 0 ] && echo "-" || echo "")
MINOPT=$([ $1 -lt 0 ] && echo "" || echo "-")
HALF_STEP=${1#-}

window_info=$(yabai -m query --windows --window)
window_gap_min=$(echo "$window_info" | jq ".frame.y")
display_max=$(yabai -m query --displays --display | jq ".frame.h")

percent=$(printf %.0f $(bc -l --expression "$window_gap_min * 100 / $display_max"))

if [[ $percent -lt $THRESHOLD ]]; then
    yabai -m window --resize bottom:0:$MAXOPT$(($HALF_STEP * 2))
    exit 0
fi

window_gap_max=$(bc -l --expression "$display_max - $(echo "$window_info" | jq ".frame.h") - $window_gap_min")
percent=$(printf %.0f $(bc -l --expression "$window_gap_max * 100 / $display_max"))
echo $percent

if [[ $percent -lt $THRESHOLD ]]; then
    yabai -m window --resize top:0:$MINOPT$(($HALF_STEP * 2))
    exit 0
fi

yabai -m window --resize bottom:0:$MAXOPT$HALF_STEP
yabai -m window --resize top:0:$MINOPT$HALF_STEP