#!/bin/bash

this_win_id=$(yabai -m query --windows --window | jq '.app')
if [[ $this_win_id == "\"Code\"" ]] ; then
    skhd --key "hyper - l"
    echo "case 1"
else
    window_info=$(yabai -m query --windows)
    target_win_id=$(echo $window_info | jq '[.[] | select(.app=="Code")][0].id')
    yabai -m window --focus $target_win_id
    echo "case 2"
fi