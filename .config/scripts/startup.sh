# Map caps lock to escape
setxkbmap -option caps:swapescape

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Disable touchscreen
xinput disable 10

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 200 80

# Manually start services whilst s6 issue persists
tmux new-session -d -s desktop-environment
tmux new-session -d -s gotty-clients
tmux new-session -d -s gotty-server gotty --permit-write --port 8022 zsh -c 'tmux new-session -s gotty-clients-$(date +%s) -t gotty-clients'
tmux new-session -d -s webrelay relay connect --name $HOSTNAME localhost:8022
