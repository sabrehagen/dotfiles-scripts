#!/bin/zsh

TOUCHPAD_ID=$(xinput --list | grep Touchpad | sed -E 's;.*=([^\t]*).*;\1;')

while true; do

  FOCUSED_WINDOW=$(xdotool getwindowfocus getwindowname)

  if [[ "$FOCUSED_WINDOW" =~ 'Google Chrome|Slack' ]]; then
    # enable touchpad for applications that require mouse
    xinput --enable $TOUCHPAD_ID
  else
    # disable touchpad for applications that don't require mouse
    xinput --disable $TOUCHPAD_ID
  fi

  sleep 0.2
done
