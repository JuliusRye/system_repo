#!/bin/bash

# Configuration
WORK_DURATION=25   # Work duration in minutes
BREAK_DURATION=5   # Break duration in minutes
TIMER_FILE="/tmp/pomodoro_timer"

# Initialize or read timer state
if [[ ! -f "$TIMER_FILE" ]]; then
    echo "$(($(date +%s) + WORK_DURATION * 60))|$((WORK_DURATION * 60))|inactive|sent" > "$TIMER_FILE"
fi

# Read the stored values of the variables
IFS='|' read -r END_TIME REMAINING_TIME STATE NOTIFICATION < "$TIMER_FILE"
CURRENT_TIME=$(date +%s)

# Handle state change
if [[ "$1" == "enable/disable" ]]; then
    if [[ "$STATE" == "inactive" ]]; then
        STATE="work"
        END_TIME=$((CURRENT_TIME + WORK_DURATION*60))
        NOTIFICATION="waiting"
    else
        STATE="inactive"
    fi
elif [[ "$1" == "start/pause" ]]; then
    if [[ "$STATE" == "work" ]]; then
        STATE="work paused"
    elif [[ "$STATE" == "work paused" ]]; then
        STATE="work"
    elif [[ "$STATE" == "break" ]]; then
        STATE="break paused"
    elif [[ "$STATE" == "break paused" ]]; then
        STATE="break"
    fi
elif [[ "$1" == "next" ]]; then
    if [[ "$STATE" == "work" || "$STATE" == "work paused" ]]; then
        STATE="break"
        END_TIME=$((CURRENT_TIME + BREAK_DURATION*60))
        NOTIFICATION="waiting"
    elif [[ "$STATE" == "break" || "$STATE" == "break paused" ]]; then
        STATE="work"
        END_TIME=$((CURRENT_TIME + WORK_DURATION))
        NOTIFICATION="waiting"
    fi
fi

# Update time
if [[ "$STATE" == "work" || "$STATE" == "break" ]]; then
    REMAINING_TIME=$((END_TIME - CURRENT_TIME))
elif [[ "$STATE" == "work paused" || "$STATE" == "break paused" ]]; then
    END_TIME=$((CURRENT_TIME + REMAINING_TIME))
fi
if [[ "$REMAINING_TIME" -lt 0 ]]; then
    REMAINING_TIME=0
    # Handle notifications
    if [[ $NOTIFICATION == "waiting" ]]; then
        NOTIFICATION="sent"
        if [[ "$STATE" == "work" || "$STATE" == "work paused" ]]; then
            notify-send -i timeshift --icon=.config/waybar/scripts/time.png -t 1000000 "Time to take a 5 minute break"
        elif [[ "$STATE" == "break" || "$STATE" == "break paused" ]]; then
            notify-send -i timeshift --icon=.config/waybar/scripts/time.png -t 1000000 "Time to get back to work"
        fi
    fi
fi

# Pick the icon for the current state
if [[ $STATE == "inactive" ]]; then
    ICON="󰣇"
elif [[ "$STATE" == "work" ]]; then
    ICON=""
elif [[ "$STATE" == "work paused" ]]; then
    ICON="-󱖐"
elif [[ "$STATE" == "break" ]]; then
    ICON=""
elif [[ "$STATE" == "break paused" ]]; then
    ICON="-󱖐"
fi

# Update the pomodoro timer
if [[ $STATE == "inactive" ]]; then
    printf "%s" "$ICON"
else
    MINUTES=$((REMAINING_TIME / 60))
    SECONDS=$((REMAINING_TIME % 60))
    printf "%s %02d:%02d" "$ICON" "$MINUTES" "$SECONDS"
fi
echo "$END_TIME|$REMAINING_TIME|$STATE|$NOTIFICATION" > "$TIMER_FILE"