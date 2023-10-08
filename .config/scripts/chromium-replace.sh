WORKSPACE_COUNTER=1
WORKSPACE_NUMBERS=$(i3-msg -t get_workspaces | jq '.[].num' | sort -n)

for WORKSPACE_NUMBER in $WORKSPACE_NUMBERS; do

  WORKSPACE_ID=$(( $WORKSPACE_NUMBER - 1 ))
  CHROMIUM_WINDOW=$(xdotool search --desktop "$WORKSPACE_ID" --class chromium | head -1)

  echo WORKSPACE_ID $WORKSPACE_ID CHROMIUM_WINDOW $CHROMIUM_WINDOW

  if [ ! -z "$CHROMIUM_WINDOW" ]; then

    # Switch to workspace
    i3-msg workspace $WORKSPACE_NUMBER

    # Focus chromium-browser
    xdotool windowactivate $CHROMIUM_WINDOW

    # Open placeholder in sibling container
    i3-msg split h
    i3-msg exec xterm
    i3-msg focus parent
    i3-msg mark PLACEHOLDER
  fi

  WORKSPACE_COUNTER=$(( $WORKSPACE_COUNTER + 1 ))

done

sleep 0.5

# Kill chromium
pkill -f chromium-browser

# Start chromium
i3-msg "exec chrome --class=i3-chromium-launch"

sleep 1.5

# Remove placeholders
pkill -f xterm
