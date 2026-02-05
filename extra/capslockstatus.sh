#!/usr/bin/env bash

status=$(cat /sys/class/leds/input*::capslock/brightness)
status=${status:0:1}

if [[ "$status" -eq "0" ]]; then
    echo '{"text":"󰘲","class":"off"}'
else
    echo '{"text":"󰘲","class":"on"}'
fi
exit 0
