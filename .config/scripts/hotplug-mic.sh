udevadm monitor | \
  grep -E --line-buffered 'add.*usb.*sound/card[0-9]+ \(' | \
  while read -r event; do
    card=$(echo "$event" | grep -o 'card[0-9]*' | tail -1 | grep -o '[0-9]*')
    sleep 1
    grep -qi 'yeti\|microphone' /proc/asound/card${card}/id 2>/dev/null || continue
    playback=$(grep "\[ ${card}-.*digital audio playback" /proc/asound/devices | awk '{print $1}' | tr -d ':')
    capture=$(grep "\[ ${card}-.*digital audio capture" /proc/asound/devices | awk '{print $1}' | tr -d ':')
    control=$(grep "\[ ${card}\].*control" /proc/asound/devices | awk '{print $1}' | tr -d ':')
    sudo mknod /dev/snd/pcmC${card}D0p c 116 $playback
    sudo mknod /dev/snd/pcmC${card}D0c c 116 $capture
    sudo mknod /dev/snd/controlC${card} c 116 $control
    sudo chown root:audio /dev/snd/pcmC${card}D0p /dev/snd/pcmC${card}D0c /dev/snd/controlC${card}
    pkill -x wireplumber
    sleep 1
    wireplumber &
  done
