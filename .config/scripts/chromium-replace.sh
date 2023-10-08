FOCUSED_WINDOW=$(xdotool getactivewindow 2>/dev/null || echo no-focused-window)

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
