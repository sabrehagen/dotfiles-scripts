BYPASS_WINDOWS="google-chrome|pcmanfm|slack"
MOUSE_DEVICE_ID=$(xinput --list | grep Synaptics | sed -E 's;.*=([^\t]*).*;\1;')

# Disable mouse by default
WINDOW_REQUIRES_MOUSE=1
BYPASS_ENABLED=1

# Monitor focus of windows that require mouse
while true; do

  # Monitor alt KeyPress event
  ALT_PRESSED=$(echo $(timeout 0.2 xinput --test-xi2 --root) | grep -Eq 'EVENT type 2.*KeyPress.*detail: 64'; echo $?)
  if [ "$ALT_PRESSED" -eq 0 ]; then
    BYPASS_ENABLED=0
  fi

  # Monitor alt KeyRelease event
  ALT_RELEASED=$(echo `timeout 0.2 xinput --test-xi2 --root` | grep -Eq 'EVENT type 3.*KeyRelease.*detail: 64'; echo $?)
  if [ "$ALT_RELEASED" -eq 0 ]; then
    BYPASS_ENABLED=1
  fi

  FOCUSED_WINDOW=$(xprop -id $(xdotool getwindowfocus) | grep WM_CLASS | sed -E 's;.*"([^"]*)";\1;' | tr A-Z a-z)

  # Check if the focused window requires mouse
  WINDOW_REQUIRES_MOUSE=$(echo "$FOCUSED_WINDOW" | grep -Eq "$BYPASS_WINDOWS"; echo $?)

  # Enable mouse for applications that require mouse or if the bypass is enabled
  if [ "$WINDOW_REQUIRES_MOUSE" -eq 0 ] || [ "$BYPASS_ENABLED" -eq 0 ]; then
    # Debug logging
    echo ENABLING MOUSE

    # Enable the mouse
    xinput --enable $MOUSE_DEVICE_ID
  else
    # Debug logging
    echo DISABLING MOUSE

    # Disable mouse for applications that don't require mouse
    xinput --disable $MOUSE_DEVICE_ID
  fi

  # Debug logging
  echo ALT_PRESSED: $ALT_PRESSED
  echo ALT_RELEASED: $ALT_RELEASED
  echo BYPASS_ENABLED: $BYPASS_ENABLED
  echo FOCUSED_WINDOW: $FOCUSED_WINDOW
  echo WINDOW_REQUIRES_MOUSE: $WINDOW_REQUIRES_MOUSE
  echo

done
