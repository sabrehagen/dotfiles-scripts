# Map caps lock to escape
setxkbmap -option caps:swapescape

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Disable touchscreen
xinput disable 10

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 175 80
