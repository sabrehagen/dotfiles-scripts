#!/bin/bash

# map caps lock to escape
setxkbmap -option caps:swapescape

# map print screen to menu
xmodmap -e "keycode 107 = Menu"

# disable touchscreen
xinput disable 10
