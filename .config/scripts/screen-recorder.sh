#!/bin/bash
VIDEO_PATH=videos/recording-$(date +%F%T).mp4
OUTPUT_PATH=$HOME/$VIDEO_PATH

stop_recording_hotkey() {
  CTRL_PRESSED=0
  ALT_PRESSED=0
  EIGHT_PRESSED=0

  KEYBOARD_ID=$(xinput list --id-only "keyboard:AT Translated Set 2 keyboard")

  xinput test $KEYBOARD_ID | while read -r KEY_EVENT; do
    case "$KEY_EVENT" in
      *"key press"*"37"*) # Left Control
        CTRL_PRESSED=1
        ;;
      *"key release"*"37"*)
        CTRL_PRESSED=0
        ;;
      *"key press"*"64"*) # Left Alt
        ALT_PRESSED=1
        ;;
      *"key release"*"64"*)
        ALT_PRESSED=0
        ;;
      *"key press"*"17"*) # 8 key
        EIGHT_PRESSED=1
        ;;
      *"key release"*"17"*)
        EIGHT_PRESSED=0
        ;;
    esac

    if [ $CTRL_PRESSED -eq 1 ] && [ $ALT_PRESSED -eq 1 ] && [ $EIGHT_PRESSED -eq 1 ]; then
      pkill -f 'ffmpeg.*x11grab'
      exit
    fi
  done
}

set -- $(slop -f '%x %y %w %h' 2>/dev/null)
X=$1 Y=$2 W=$3 H=$4

if [ ${#W} -gt 0 ]; then
  # Kill any previous screen recording ffmpeg process as it locks the alsa input devices
  pkill -f 'ffmpeg.*x11grab'

  echo Started Recording

  # If script is launched from a scratchpad, hide the scratchpad
  LAUNCH_WINDOW=$(xdotool getwindowfocus | xargs xdotool getwindowname)
  if [ "$LAUNCH_WINDOW" = "scratchpad_terminal" ]; then
    i3-msg '[title="scratchpad_terminal"] scratchpad show' >/dev/null
  fi

  stop_recording_hotkey &

  ffmpeg \
    -f x11grab \
    -s ${W}x${H} \
    -framerate 60 \
    -thread_queue_size 512 \
    -i $DISPLAY.0+$X,$Y \
    -f alsa -ac 2 -i hw:1,0 -acodec mp3 \
    -vcodec libx264 \
    -qp 18 \
    -preset ultrafast \
    $OUTPUT_PATH \
    2>/dev/null

  echo $OUTPUT_PATH
  $HOME/.config/scripts/compress-video.sh $OUTPUT_PATH &

  IS_FIRST_NOTIFICATION=true
  NOTIFICATION_TITLE='Screen Recording Output'
  NOTIFICATION_BODY=\~/$VIDEO_PATH
  COPY_PATH='Copy Path'
  PLAY_RECORDING='Play Recording'

  show_recording_notification() {
    if [ "$IS_FIRST_NOTIFICATION" ]; then
      ACTION_NUMBER=$(notify-send "$NOTIFICATION_TITLE" $NOTIFICATION_BODY --action "$COPY_PATH" --action "$PLAY_RECORDING" 2>/dev/null)
      [ -n "$ACTION_NUMBER" ] && { [ "$ACTION_NUMBER" = "0" ] && NOTIFICATION_ACTION=$COPY_PATH || NOTIFICATION_ACTION=$PLAY_RECORDING; }
    else
      ACTION_NUMBER=$(notify-send "$NOTIFICATION_TITLE" $NOTIFICATION_BODY --action "$PLAY_RECORDING" --action "$COPY_PATH" 2>/dev/null)
      [ -n "$ACTION_NUMBER" ] && { [ "$ACTION_NUMBER" = "0" ] && NOTIFICATION_ACTION=$PLAY_RECORDING || NOTIFICATION_ACTION=$COPY_PATH; }
    fi

    unset IS_FIRST_NOTIFICATION

    if [ "$NOTIFICATION_ACTION" = "$PLAY_RECORDING" ]; then
      mpv $OUTPUT_PATH &>/dev/null
      show_recording_notification
    elif [ "$NOTIFICATION_ACTION" = "$COPY_PATH" ]; then
      echo -n $OUTPUT_PATH | xclip -selection clipboard
    fi
  }

  show_recording_notification

  # Wait for video compression background job to complete
  wait
fi
