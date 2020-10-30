# get random font
showfigfonts > /dev/null

if [ ! $? = 0 ]
then
  echo "showfigfonts is not installed"
  sudo apt-get showfigfonts
fi


RANDOM_FONT=$(showfigfonts | grep -E ".+? :" | rev | cut -c3- | rev | shuf -n 1)

RF_1="${RANDOM_FONT}.flf"
RF_2="${RANDOM_FONT}.flc"


figlet -f "$RF_1" "$1" -m 5 || figlet -f "$RF_2" "$1" -m 2
