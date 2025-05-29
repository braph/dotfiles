#!/bin/bash

unset CDPATH
set -u +o histexpand

PID=$(xdotool getwindowfocus getwindowpid)
STATE=$(cut -d' ' -f3 /proc/$PID/stat)

if [[ "$STATE" == 'T' ]]; then
   # stopped
   #xmessage "CONT $PID"
   kill -CONT $PID
else
   #xmessage "STOP $PID"
   kill -STOP $PID
fi

