# MIT License
#
# Copyright (c) 2024 Krit Cholapand
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import argparse
import json
import subprocess

YABAI = '/opt/homebrew/bin/yabai'
JQ = '/opt/homebrew/bin/jq'


def main():
    # -----------------
    # Create the parser
    # -----------------

    parser = argparse.ArgumentParser(
        description='A script that performs different actions based on the arguments provided.'
    )

    parser.add_argument(
        '--action',
        type=str,
        choices=['send', 'sendfamily', 'goto'],
        required=True,
        help='Action to perform. Choices are: send, sendfamily, goto',
    )

    parser.add_argument(
        '--wrap',
        action='store_true',
        help='Toggle to enable space wrapping on space_sel is next/prev',
    )

    parser.add_argument(
        '--all-display',
        action='store_true',
        help='treat space_sel as space index next - prev across display',
    )

    parser.add_argument(
        'space_sel',
        type=str,
        help='Specify the space selection action. Choices are: next, prev, or a space order within display if --all-display is not specify',
    )

    args = parser.parse_args()

    if args.space_sel not in ['next', 'prev'] and not args.space_sel.isnumeric():
        raise ValueError(f"Invalid value for 'space_sel': {args.space_sel}")

    # -----
    # logic
    # -----

    # ---- query
    # spaces_info = subprocess.run(f'{YABAI} -m query --spaces')
    process = subprocess.Popen(
        [
            'yabai',
            '-m',
            'query',
            '--spaces',
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
    )
    proc_out, proc_err = process.communicate()
    spaces_info = json.loads(proc_out)

    # ---- construct data
    current_display = 0
    current_space = 0
    display_dict = {}

    # construct data in one go
    for space_info in spaces_info:
        display = space_info['display']
        space = space_info['index']

        # ? quite confident that yabai query is sorted
        if display not in display_dict:
            display_dict[display] = []
        display_dict[display].append(space)

        if space_info['has-focus']:
            current_display = display
            current_space = space

    is_all_display = args.all_display
    if is_all_display:
        min_space = min([min(spaces) for spaces in display_dict.values()])
        max_space = max([max(spaces) for spaces in display_dict.values()])
    else:
        min_space = display_dict[current_display][0]
        max_space = display_dict[current_display][-1]
    space_n = max_space - min_space + 1

    # do nothing if no space to move
    if space_n == 1:
        return

    space_sel = args.space_sel
    is_wrap = args.wrap

    if space_sel == 'next':
        if current_space == max_space and not is_wrap:
            return
        target_space = min_space if current_space == max_space else current_space + 1
    elif space_sel == 'prev':
        if current_space == min_space and not is_wrap:
            return
        target_space = max_space if current_space == min_space else current_space - 1
    else:
        space_sel = int(space_sel)
        if is_all_display:
            target_space = max(min(space_sel, max_space), min_space)
        else:
            target_space = min_space + space_sel - 1

        # clipping inside available space
        target_space = max(min(target_space, max_space), min_space)

    # do nothing if no space to move
    if target_space == current_space:
        return

    # print(f'target_space: {target_space}')

    # ---- action
    if args.action == 'goto':
        # strategy 1
        if target_space <= 12:
            keymap = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', '-', '=']
            _ = subprocess.run(['skhd', '--key', f'hyper - {keymap[target_space-1]}'])
            return

        # strategy 2
        space_win = {
            space_info['index']: space_info['first-window']
            for space_info in spaces_info
        }
        window_id = space_win[target_space]
        if window_id != 0:
            _ = subprocess.run(['yabai', '-m', 'window', '--focus', f'{window_id}'])

    if args.action == 'send':
        proc_out = subprocess.run(
            "yabai -m query --windows --window | jq '.id'",
            shell=True,
            capture_output=True,
            text=True,
        )
        window_id = proc_out.stdout.strip()
        _ = subprocess.run(['yabai', '-m', 'window', '--space', f'{target_space}'])
        _ = subprocess.run(['yabai', '-m', 'window', '--focus', f'{window_id}'])
        return

    if args.action == 'sendfamily':
        raise NotImplementedError


if __name__ == '__main__':
    main()
