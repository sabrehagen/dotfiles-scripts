APPS_DIR=$HOME/apps
ARCHIVE_DIR=archived
LAUNCH_APP=$1

# If an application was supplied
if [ -n "$LAUNCH_APP" ]; then

  # Launch the supplied application
  find $APPS_DIR/*/* -maxdepth 1 -type f -name $LAUNCH_APP -not -path "$APPS_DIR/$ARCHIVE_DIR/*" -exec {} \; &

else

  # Configure dmenu
  DMENU_FG=$(cat $HOME/.cache/wal/colors | head -1)
  DMENU_BG=$(cat $HOME/.cache/wal/colors | tail -1)
  DMENU_COMMAND="dmenu -nb $DMENU_FG -nf $DMENU_BG -sb $DMENU_BG -sf $DMENU_FG"

  # Get application paths
  APP_PATHS=$(find $APPS_DIR/*/* -maxdepth 0 ! -path . -type d | sed -E "s;$APPS_DIR/;;" | sed 's;de-;;' | grep -v $ARCHIVE_DIR)

  # Present application names for user selection
  APP_NAME=$(echo $APP_PATHS | tr ' ' \\n | $DMENU_COMMAND)

  # Restore application path from name
  APP_PATH=$(echo $APP_NAME | sed -E 's;([^/]*/);\1de-;')

  # Get the application binary name
  APP_BINARY=$(echo $APP_PATH | sed 's;.*/;;')

  # Run selected application
  $APPS_DIR/$APP_PATH/$APP_BINARY &

fi
