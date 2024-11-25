#!/bin/bash

# Configuration
WORK_DURATION=25   # Work duration in minutes
BREAK_DURATION=5   # Break duration in minutes
TIMER_FILE="/tmp/pomodoro_timer"
STATE_FILE="/tmp/pomodoro_state"

# Initialize or read timer state
if [[ ! -f "$TIMER_FILE" ]]; then
    echo "$(($(date +%s) + WORK_DURATION * 60))|work|running" > "$TIMER_FILE"
fi

IFS='|' read -r END_TIME STATE STATUS < "$TIMER_FILE"

# Handle click events
if [[ "$1" == "right" && "$STATUS" != "inactive" ]]; then
    # Pause the timer in its current state
    if [[ $STATUS == "running" ]]; then
        STATUS="paused"
    else
        STATUS="running"
    fi
    echo "$END_TIME|$STATE|$STATUS" > "$TIMER_FILE"
elif [[ "$1" == "left" && "$STATUS" != "inactive" ]]; then
    # Jump to the next state
    if [[ $STATE == "work" ]]; then
        STATE="break"
        END_TIME=$(($(date +%s) + BREAK_DURATION * 60))
    else
        STATE="work"
        END_TIME=$(($(date +%s) + WORK_DURATION * 60))
    fi
    echo "$END_TIME|$STATE|$STATUS" > "$TIMER_FILE"
elif [[ "$1" == "middle" ]]; then
    # Toggle enable/disable
    if [[ $STATUS == "running" ]]; then
        STATUS="inactive"
    else
        STATUS="running"
        STATE="work"
        END_TIME=$(($(date +%s) + WORK_DURATION * 60))
    fi
    echo "$END_TIME|$STATE|$STATUS" > "$TIMER_FILE"
fi

# Update time and behavior
CURRENT_TIME=$(date +%s)
if [[ $STATUS == "running" ]] && [[ $CURRENT_TIME -ge $END_TIME ]]; then
    STATUS="stopped"
    echo "$END_TIME|$STATE|$STATUS" > "$TIMER_FILE"
fi

# Calculate remaining time
if [[ $STATUS == "running" ]]; then
    REMAINING_TIME=$((END_TIME - CURRENT_TIME))
elif [[ $STATUS == "paused" ]]; then
    REMAINING_TIME=$((END_TIME - CURRENT_TIME))
    END_TIME=$((END_TIME+1)) # Adds a second every second
    echo "$END_TIME|$STATE|$STATUS" > "$TIMER_FILE"
else
    REMAINING_TIME=0
fi
MINUTES=$((REMAINING_TIME / 60))
SECONDS=$((REMAINING_TIME % 60))

# Display state and time
if [[ $STATE == "work" ]]; then
    ICON=""  # Work icon
else
    ICON=""  # Break icon
fi
if [[ $STATUS == "paused" ]]; then
    ICON="󱖐"  # Inactive icon
fi

if [[ $STATUS == "inactive" ]]; then
    printf "󰣇"  # Inactive icon
else
    printf "%s %02d:%02d\n" "$ICON" "$MINUTES" "$SECONDS"
fi

