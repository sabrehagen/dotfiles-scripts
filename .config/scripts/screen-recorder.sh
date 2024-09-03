#!/bin/bash
if pidof ffmpeg; then
    killall ffmpeg
    notify-send 'Stopped Recording!' --icon=dialog-information
  else
    slop=$(slop -f "%x %y %w %h")
    read -r X Y W H < <(echo $slop)
    OUTPUT_FILE=$HOME/videos/recording-$(date +%F%T).mp4

    # only start recording if we give a width (e.g we press escape to get out of slop - don't record)
    if [ ${#W} -gt 0 ]; then
      notify-send 'Started Recording!' --icon=dialog-information

      # records without audio input. for audio add "-f alsa -i pulse" to the line below (at the end before \, without "")
      ffmpeg \
        -f x11grab \
        -s "$W"x"$H" \
        -framerate 60 \
        -thread_queue_size 512 \
        -i $DISPLAY.0+$X,$Y \
        -f alsa -ac 2 -i hw:1,0 -acodec mp3 \
        -vcodec libx264 \
        -qp 18 \
        -preset ultrafast \
        $OUTPUT_FILE

      echo $OUTPUT_FILE

      $HOME/.config/scripts/compress-screen-recording.sh $OUTPUT_FILE
    fi
fi
