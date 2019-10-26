BRIGHTNESS=$(xrandr --verbose | grep -m 1 -i brightness | cut -f2 -d ' ')

if [ "$1" = '+' ]; then
  NEW_BRIGHTNESS=$(echo "$BRIGHTNESS + 0.05" | bc)
  if [ "$(echo "$NEW_BRIGHTNESS > 1.0" | bc)" -eq 1 ]; then
    NEW_BRIGHTNESS='1.0'
  fi
elif [ "$1" = '-' ]; then
  NEW_BRIGHTNESS=$(echo "$BRIGHTNESS - 0.05" | bc)
  if [ "$(echo "$NEW_BRIGHTNESS < 0.0" | bc)" -eq 1 ]; then
    NEW_BRIGHTNESS='0.0'
  fi
fi

xrandr --output eDP-1 --brightness "$NEW_BRIGHTNESS"
