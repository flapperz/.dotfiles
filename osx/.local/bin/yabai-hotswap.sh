#!/bin/bash
# TODO: insert back to same sibling
# TODO: cycle through window of the same appication (vscode)

STATEFILE=$(echo /tmp/flap-yabai-hotswap-state-$2.txt)

# echo $target_win_id


if [[ ! -f $STATEFILE || $(cat $STATEFILE) == empty ]] ; then
    window_info=$(yabai -m query --windows)
    target_win_id=$(echo $window_info | jq --arg appname $1 '.[] | select(.app==$appname).id')
    home_space=$(echo $window_info | jq --arg appname $1 '.[] | select(.app==$appname).space')
    this_win_id=$(yabai -m query --windows --window | jq '.id')

    yabai -m window --focus $target_win_id
    yabai -m window --focus $target_win_id
    yabai -m window $target_win_id --warp $this_win_id

    echo $target_win_id > $STATEFILE
    echo $home_space >> $STATEFILE
    echo $this_win_id >> $STATEFILE
else
    # target_win_id=sed -n 1p
    target_win_id=$(sed -n 1p $STATEFILE)
    home_space=$(sed -n 2p $STATEFILE)
    this_win_id=$(sed -n 3p $STATEFILE)

    yabai -m window $target_win_id --space $home_space
    yabai -m window --focus $this_win_id
    echo empty > $STATEFILE
fi