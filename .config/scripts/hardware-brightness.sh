DDC_CACHE=$HOME/.ddcutil_cache
INTEL_BACKLIGHT=/sys/class/backlight/intel_backlight

set_brightness_intel() { $HOME/.config/scripts/host-ssh.sh "echo $1 | sudo tee $INTEL_BACKLIGHT/brightness"; }
set_brightness_ddc() { flock $DDC_CACHE sudo ddcutil --bus 1 setvcp 10 $1 && echo $1 > $DDC_CACHE; }

if $HOME/.config/scripts/host-ssh.sh test -d $INTEL_BACKLIGHT; then
  BRIGHTNESS=$($HOME/.config/scripts/host-ssh.sh sudo cat $INTEL_BACKLIGHT/actual_brightness)
  INCREMENT=${2-1000}
  SET_BRIGHTNESS=set_brightness_intel
else
  BRIGHTNESS=$(cat $DDC_CACHE 2>/dev/null || sudo ddcutil --bus 1 getvcp --brief 10 2>/dev/null | awk '{print $4}')
  INCREMENT=${2-10}
  SET_BRIGHTNESS=set_brightness_ddc
fi

if [ "$1" = '+' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS + $INCREMENT))
elif [ "$1" = '-' ]; then
  NEW_BRIGHTNESS=$(($BRIGHTNESS - $INCREMENT))
fi

$SET_BRIGHTNESS $NEW_BRIGHTNESS
