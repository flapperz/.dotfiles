#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title list ssh config
# @raycast.mode fullOutput

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.author Krit Cholapand

# Initialize an output variable
output=""

# Process the SSH config and build the output string
output=$(awk '
# Find the maximum length of Host for alignment
/^[ \t]*Host[ \t]+/ {
    if (length($2) > max_host_length) {
        max_host_length = length($2)
    }
}
END {
    # Prepare a single echo statement
    output = ""
    for (i = 1; i <= count; i++) {
        if (host[i] && hostname[i]) {
            output = output sprintf("%-*s: %s\n", max_host_length, host[i], hostname[i])
        }
    }
    print output
}
{
    # Capture Host and HostName for processing
    if (/^[ \t]*Host[ \t]+/) {
        current_host = $2
    }
    if (/^[ \t]*HostName[ \t]+/) {
        host[++count] = current_host
        hostname[count] = $2
    }
}
' ~/.ssh/config)

echo -e "$output"
