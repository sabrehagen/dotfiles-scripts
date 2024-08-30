BUILD_TMUX_SESSION=$(tmux list-sessions | grep build-dotfiles.*: | cut -d: -f1 | sort -nr | head -1)

if [ -n "$BUILD_TMUX_SESSION" ]; then
  BUILD_LOG_SESSION_NAME=i3bar_desktop-environment-build-$(date +%s)

  # Kill any previous build log session
  tmux kill-session -t i3bar_desktop-environment-build*

  # If mouse coordinates are not set, script has been invoked manually, not by clicking the desktop-environment-build i3block
  if [ -z "$BLOCK_X" ] && [ -z "$BLOCK_Y" ]; then
    # Capture the current mouse position
    eval $(xdotool getmouselocation --shell)

    # Move the mouse to the desktop-environment-build i3block
    xdotool mousemove 742 1079
  fi

  # Create a new build log viewer
  alacritty \
    --option window.dimensions.columns=108 \
    --option window.dimensions.lines=50 \
    --title i3bar_desktop-environment-build \
    --command zsh -c "tmux new-session -s $BUILD_LOG_SESSION_NAME -t $BUILD_TMUX_SESSION" >/dev/null 2>&1 &

  # Turn off status bar in build log viewer session
  until tmux list-sessions | grep -q $BUILD_LOG_SESSION_NAME; do sleep 0.05; done
  tmux set-option -t $BUILD_LOG_SESSION_NAME status off

  # If the script has been invoked manually, return mouse to its original position
  if [ -z "$BLOCK_X" ] && [ -z "$BLOCK_Y" ]; then
    # Move mouse to coordinates captured by xdotool
    xdotool mousemove $X $Y

    # Focus build log viewer after moving mouse
    xdotool windowactivate $(xdotool search --name i3bar_desktop-environment-build) 2>/dev/null
  fi
fi
