EXCLUDED_WINDOWS="google-chrome|pcmanfm|slack"
TOUCHPAD_ID=$(xinput --list | grep Touchpad | sed -E 's;.*=([^\t]*).*;\1;')

while true; do
  FOCUSED_WINDOW=$(xprop -id $(xdotool getwindowfocus) | grep WM_CLASS | sed -E 's;.*"([^"]*)";\1;' | tr A-Z a-z)

  if [ $(echo "$FOCUSED_WINDOW" | grep -Eq "$EXCLUDED_WINDOWS"; echo $?) -eq 0 ]; then
    # enable touchpad for applications that require mouse
    xinput --enable $TOUCHPAD_ID
  else
    # disable touchpad for applications that don't require mouse
    xinput --disable $TOUCHPAD_ID
  fi

  sleep 0.2
done
