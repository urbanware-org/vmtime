#!/usr/bin/env bash

# ============================================================================
# VMtime - Simple virtual machine time measurement scripts
# Start script
# Copyright (C) 2020 by Ralf Kilian
# Distributed under the MIT License (https://opensource.org/licenses/MIT)
#
# GitHub: https://github.com/urbanware-org/vmtime
# GitLab: https://gitlab.com/urbanware-org/vmtime
# ============================================================================

version="1.0.0"

# Commands to control the virtual machine
cmd_start="virsh start"
cmd_stop="virsh shutdown"
cmd_list="virsh list --all"

# Timeout related values
count_max_ping=180      # number of pings to send (while waiting on answer)

# Command-line arguments
vm_name="$1"            # name of the virtual machine
vm_ipaddr="$2"          # IP address of the virtual machine

# Check if missing
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage:  VM_NAME IP_ADDRESS"
    exit 2
fi

# Check if the virtual machine is running at all by reading out its status ID.
# If the status ID is a hyphen ('-'), the system is shut down.
vm_id=$($cmd_list | grep $vm_name | awk '{ print $1 }')
if [ ! $vm_id = "-" ]; then
    echo "Virtual machine is already running. Exiting."
    exit 1
fi

# Start time measurement
start_time=$SECONDS

# Status related
ping_success=0
ping_count=0

# Send shutdown signal
echo "Sending start signal."
$cmd_start $vm_name &>/dev/null
echo "Waiting for ping answer."

while [ $ping_count -lt $count_max_ping ]; do
    ping $vm_ipaddr -c 1 &>/dev/null
    if [ $? -eq 0 ]; then
        echo "Ping successful."
        ping_success=1
        break
    else
        ping_count=$(( ping_count + 1 ))
    fi
done
if [ $ping_success -ne 1 ]; then
    echo "Ping timeout. Exiting."
    exit 1
fi

# Return passed time
elapsed_time=$(( SECONDS - start_time ))
echo "Elapsed time: $elapsed_time seconds"

# EOF
