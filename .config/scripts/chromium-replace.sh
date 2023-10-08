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
    i3-msg exec open
    i3-msg mark PLACEHOLDER
  fi

  WORKSPACE_COUNTER=$(( $WORKSPACE_COUNTER + 1 ))

done

# Kill chromium
pkill -f chromium-browser

i3-msg [con_mark=PLACEHOLDER] focus

# Start chromium
i3-msg "exec chrome --class=i3-chromium-launch"

# Remove placeholders
i3-msg [con_mark=PLACEHOLDER] kill

exit 0

# Focus placeholder
i3-msg [con_mark=PLACEHOLDER] focus
i3-msg kill


# Open chrome in the placeholder
chrome

exit 0

# i3-msg swap container with mark PLACEHOLDER

# for each chromium window

i3-msg focus chromium window
i3-msg "split h"
i3-msg open
i3-msg mark open placeholder

# end for

i3-msg close windows matching chromium class

# start chrome on hidden scratchpad
i3-msg set window rule chrome scratchpad_chrome
chrome &

# wait for chromium windows to appear
xdotool search for chromium windows

# for each chrome window

# move window to open mark
i3-msg move window to open mark

# end for

if [ ! -z "$MATCHING_WORKSPACE_WINDOW" ]; then
  xdotool windowactivate $MATCHING_WORKSPACE_WINDOW
  break
fi
