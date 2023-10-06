touchWindow () {
  $HOME/.config/i3/move-to-next-window-of-type.sh $1
  xdotool key tab
  sleep 10
}

while true; do
  touchWindow slack
  touchWindow google-chrome
done
