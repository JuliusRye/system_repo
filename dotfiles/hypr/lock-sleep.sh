#!/bin/bash

# Command to check if hyprlock is running
LOCK_SCREEN_CMD="pgrep -x hyprlock"

if $LOCK_SCREEN_CMD > /dev/null
then
    # Screen is already locked, put the system to sleep
    systemctl suspend
else
    # Screen is not locked, lock the screen
    hyprlock
fi
