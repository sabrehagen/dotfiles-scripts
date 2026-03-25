udevadm monitor | \
  grep -E --line-buffered '(add|remove).*usb.*sound/card[0-9]+ \(' | \
  while read -r event; do
    card=$(echo "$event" | grep -o 'card[0-9]*' | tail -1 | grep -o '[0-9]*')
    if echo "$event" | grep -q '^KERNEL.*add'; then
      sleep 1
      grep -qi 'yeti\|microphone' /proc/asound/card${card}/id 2>/dev/null || continue
      playback=$(grep "\[ ${card}-.*digital audio playback" /proc/asound/devices | awk '{print $1}' | tr -d ':')
      capture=$(grep "\[ ${card}-.*digital audio capture" /proc/asound/devices | awk '{print $1}' | tr -d ':')
      control=$(grep "\[ ${card}\].*control" /proc/asound/devices | awk '{print $1}' | tr -d ':')
      sudo rm -f /dev/snd/pcmC${card}D0p /dev/snd/pcmC${card}D0c /dev/snd/controlC${card}
      sudo mknod /dev/snd/pcmC${card}D0p c 116 $playback
      sudo mknod /dev/snd/pcmC${card}D0c c 116 $capture
      sudo mknod /dev/snd/controlC${card} c 116 $control
      sudo chmod 0660 /dev/snd/pcmC${card}D0p /dev/snd/pcmC${card}D0c /dev/snd/controlC${card}
      sudo chown root:audio /dev/snd/pcmC${card}D0p /dev/snd/pcmC${card}D0c /dev/snd/controlC${card}
    elif echo "$event" | grep -q '^KERNEL.*remove'; then
      sudo rm -f /dev/snd/pcmC${card}D0p /dev/snd/pcmC${card}D0c /dev/snd/controlC${card}
    fi
    pkill -x wireplumber; while pgrep -x wireplumber > /dev/null; do sleep 0.1; done
  done
