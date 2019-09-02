# Swap caps lock and escape
setxkbmap -option caps:swapescape

# Swap right alt and right control
setxkbmap -option ctrl:ralt_rctrl
setxkbmap -option ctrl:rctrl_ralt

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140

# Start the tmux server for long lived services
tmux start-server

# Start desktop environment shell
tmux new-session \
  -d \
  -s desktop-environment-shell \
  zsh --login \
  2>/dev/null

# Start hotkeys
tmux new-session \
  -d \
  -s sxhkd \
  sxhkd \
  2>/dev/null

# Start transmission
tmux new-session -d -s transmission \
  transmission-daemon \
  --bind-address-ipv4 localhost \
  --config-dir $HOME/.config/transmission \
  --download-dir $HOME/torrents \
  --foreground \
  --no-auth \
  --rpc-bind-address localhost \
  --watch-dir $HOME/torrents/.watch \
  2>/dev/null

# Remove ssh socket if no ssh-agent is using it, otherwise the ssh-agent below will fail to start
SSH_AGENT_EXISTS=$(ps aux | grep $SSH_AUTH_SOCK | grep -v grep | cut -f 3 -d\ )
SSH_SOCKET_EXISTS=$(test -f $SSH_AUTH_SOCK || echo $?)
if [ -z "$SSH_AGENT_EXISTS" ] && [ "$SSH_SOCKET_EXISTS" -eq 1 ]; then
  pkill -f ssh-agent
  rm $SSH_AUTH_SOCK 2>/dev/null
fi

# Start the ssh-agent
tmux new-session \
  -d \
  -s ssh-agent \
  ssh-agent -D -a $SSH_AUTH_SOCK \
  2>/dev/null
