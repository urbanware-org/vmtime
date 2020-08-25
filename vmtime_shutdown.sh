#!/usr/bin/env bash

# ============================================================================
# VMtime - Simple virtual machine time measurement scripts
# Shutdown script
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
count_max_shutdown=300  # number of shutdown signals to send

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
if [ $vm_id = "-" ]; then
    echo "Virtual machine is not running. Exiting."
    exit 1
fi

# Start time measurement
start_time=$SECONDS

# Status related
system_status=1
count=0

# Send shutdown signal
echo "Sending the shutdown signal."
$cmd_stop $vm_name &>/dev/null
echo "Waiting for the system to power off."
while [ $count -lt $count_max_shutdown ]; do
    # Check if the virtual machine is still running the same way as before
    vm_id=$($cmd_list | grep $vm_name | awk '{ print $1 }')
    if [ $vm_id = "-" ]; then
        # The virtual machine has been shut down, so restart it
        echo "System is powered off."
        system_status=0
        break
    else
        # The virtual machine is still running despite all previously sent
        # shutdown signals, so send the stop signal once again. In case the
        # system is already busy shutting down, the signal should be ignored.
        $cmd_stop $vm_name &>/dev/null
    fi
    count=$(( count + 1 ))
    sleep 1
done
if [ $system_status -ne 0 ]; then
    echo "Number of shutdown signals exceeded. Exiting."
    exit 1
fi

# Return passed time
elapsed_time=$(( SECONDS - start_time ))
echo "Elapsed time: $elapsed_time seconds"

# EOF
