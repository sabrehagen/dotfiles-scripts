# Map caps lock to escape
setxkbmap -option caps:swapescape

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Disable touchscreen
xinput disable 10
