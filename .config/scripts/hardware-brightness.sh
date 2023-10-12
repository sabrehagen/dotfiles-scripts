BRIGHTNESS=$($HOME/.config/scripts/host-ssh.sh sudo cat /sys/class/backlight/intel_backlight/actual_brightness)
INCREMENT=${2-1000}

if [ "$1" = '+' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS + $INCREMENT))
elif [ "$1" = '-' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS - $INCREMENT))
fi

$HOME/.config/scripts/host-ssh.sh "echo $NEW_BRIGHTNESS | sudo tee /sys/class/backlight/intel_backlight/brightness"
