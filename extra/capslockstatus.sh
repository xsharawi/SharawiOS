#!/usr/bin/env bash

status=$(head -1 /sys/class/leds/input3::capslock/brightness)

if [[ "$status" -eq "0" ]]; then
    echo '{"text":"󰘲","class":"off"}'
else
    echo '{"text":"󰘲","class":"on"}'
fi
exit 0
