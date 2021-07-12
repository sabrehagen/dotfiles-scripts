BRIGHTNESS=$(~/.config/scripts/ssh-host.sh sudo cat /sys/class/backlight/intel_backlight/actual_brightness)

if [ "$1" = '+' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS + 1000))
elif [ "$1" = '-' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS - 1000))
fi

~/.config/scripts/ssh-host.sh "echo $NEW_BRIGHTNESS | sudo tee /sys/class/backlight/intel_backlight/brightness"
