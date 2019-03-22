# Swap caps lock and escape
setxkbmap -option caps:swapescape

# Swap right alt and right control
setxkbmap -option ctrl:ralt_rctrl
setxkbmap -option ctrl:rctrl_ralt

# Map right alt to control
xmodmap -e "remove Mod1 = Alt_R"
xmodmap -e "keycode 108 = Control_R"
xmodmap -e "add Control = Control_R"

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Disable touchscreen
xinput disable 10

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140

# Manually start services whilst s6 issue persists
tmux start-server
tmux new-session -d -s desktop-environment-dashboard zsh 2>/dev/null
tmux new-session -d -s desktop-environment-shell zsh --login 2>/dev/null
tmux new-session -d -s gotty-clients zsh 2>/dev/null
tmux new-session -d -s gotty-server \
  gotty \
  --permit-write \
  --port 8022 \
  zsh -c 'tmux new-session -s gotty-clients-$(date +%s) -t gotty-clients' 2>/dev/null
tmux new-session -d -s transmission \
  transmission-daemon \
  --bind-address-ipv4 localhost \
  --config-dir $HOME/.config/transmission \
  --download-dir $HOME/torrents \
  --foreground \
  --no-auth \
  --rpc-bind-address localhost \
  --watch-dir $HOME/torrents/.watch 2>/dev/null

# Always restart webrelay to pick up new environment variables
tmux set-environment -g RELAY_KEY $RELAY_KEY
tmux set-environment -g RELAY_SECRET $RELAY_SECRET
tmux kill-session -t webrelay 2>/dev/null
tmux new-session -d -s webrelay \
  relay connect \
  --crypto full \
  --region au \
  --subdomain $HOSTNAME \
  http://localhost:8022 2>/dev/null

# Insert the stemn docker host into the hosts file
yarn --cwd $HOME/repositories/stemn/stemn-backend hosts:insert 2>/dev/null &
