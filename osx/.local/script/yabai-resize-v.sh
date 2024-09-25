#!/bin/bash

THRESHOLD=5 # percent
MAXOPT=$([ $1 -lt 0 ] && echo "-" || echo "")
MINOPT=$([ $1 -lt 0 ] && echo "" || echo "-")
HALF_STEP=${1#-}

window_info=$(yabai -m query --windows --window)
display_info=$(yabai -m query --displays --display)
window_min=$(echo "$window_info" | jq ".frame.y")
display_size=$(echo "$display_info" | jq ".frame.h")
display_min=$(echo "$display_info" | jq ".frame.y")


# if hit min corner
percent=$(printf %.0f $(bc -l --expression "($window_min - $display_min) * 100 / $display_size"))

if [[ $percent -lt $THRESHOLD ]]; then
    yabai -m window --resize bottom:0:$MAXOPT$(($HALF_STEP * 2))
    exit 0
fi

# if hit max corner
window_size=$(echo "$window_info | jq ".frame.h")")
percent=$(printf %.0f $(bc -l --expression "($display_min + $display_size - $window_min - $window_size) * 100 / $display_size"))

if [[ $percent -lt $THRESHOLD ]]; then
    yabai -m window --resize top:0:$MINOPT$(($HALF_STEP * 2))
    exit 0
fi

yabai -m window --resize bottom:0:$MAXOPT$HALF_STEP
yabai -m window --resize top:0:$MINOPT$HALF_STEP