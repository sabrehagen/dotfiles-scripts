BRIGHTNESS=$(ssh jackson@localhost cat /sys/class/backlight/intel_backlight/actual_brightness)

if [ "$1" = '+' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS + 500))
elif [ "$1" = '-' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS - 500))
fi

ssh jackson@localhost "echo $NEW_BRIGHTNESS | sudo tee /sys/class/backlight/intel_backlight/brightness"
