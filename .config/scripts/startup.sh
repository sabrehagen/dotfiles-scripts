# Check if secrets required for private services have been cloned
SECRETS_EXIST=$(test -d ~/.config/vcsh/repo-private.d/dotfiles-openvpn.git; echo $?)

# Start the tmux server for long lived services
tmux start-server

# Force chrome to restore session on startup
sed -i 's/Crashed/normal/' ~/.config/google-chrome/Default/Preferences

# Start X server
tmux new-session \
  -d \
  -s xorg \
  xinit /usr/bin/i3 -- $DISPLAY vt02 \
  2>/dev/null

# Start autorandr
tmux new-session \
  -d \
  -s autorandr \
  ~/.config/scripts/monitor-hotplug.sh \
  2>/dev/null

# Start cloudstorage
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s cloudstorage \
    "CLOUD_COMPUTER_HOST_ID=$USER \
    CLOUD_COMPUTER_REDIRECT_URI=https://localhost:12345 \
    cloudstorage-fuse -f -d -o allow_other,auto_unmount ~/cloudstorage" \
    2>/dev/null
fi

# Start desktop environment shell
tmux new-session \
  -d \
  -s desktop-environment-shell \
  zsh --login \
  2>/dev/null

# Start dnsmasq
tmux new-session \
  -d \
  -s dnsmasq \
  sudo dnsmasq \
  --addn-hosts=/home/$USER/.config/dnsmasq/hostnames.txt \
  --log-queries \
  --no-daemon \
  --no-resolv \
  --strict-order \
  --server 1.0.0.1 \
  --server 1.1.1.1 \
  2>/dev/null

# Start irc
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s irc \
    irssi \
    2>/dev/null
fi

# Start jobber
tmux new-session \
  -d \
  -s jobber \
  sudo /usr/libexec/jobbermaster \
  2>/dev/null

# Start keynav
tmux new-session \
  -d \
  -s keynav \
  keynav \
  2>/dev/null

# Start netdata
tmux new-session \
  -d \
  -s netdata \
  sudo netdata \
  2>/dev/null

# Start openvpn
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s openvpn \
    sudo openvpn \
    --config ~/.config/openvpn/sydney.ovpn \
    --auth-user-pass ~/.config/openvpn/credentials \
    --dev-node ~/.config/openvpn/tun \
    2>/dev/null
fi

# Start pulseaudio
tmux new-session \
  -d \
  -s pulseaudio \
  pulseaudio \
  2>/dev/null

# Start rescuetime
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s rescuetime \
    rescuetime \
    2>/dev/null
fi

# Start mouse disabler
tmux new-session \
  -d \
  -s disable-mouse \
  ~/.config/scripts/disable-mouse.sh \
  2>/dev/null

# Start transmission
tmux new-session \
  -d \
  -s transmission \
  transmission-daemon \
  --bind-address-ipv4 localhost \
  --config-dir $HOME/.config/transmission \
  --download-dir $HOME/torrents \
  --foreground \
  --no-auth \
  --rpc-bind-address localhost \
  --watch-dir $HOME/torrents/.watch \
  2>/dev/null

# If ssh-agent isn't running but the ssh socket exists, remove it otherwise ssh-agent will fail to start
SSH_AGENT_EXISTS=$(ps aux | grep $SSH_AUTH_SOCK | grep -vq grep; echo $?)
SSH_SOCKET_EXISTS=$(test -S $SSH_AUTH_SOCK; echo $?)
if [ "$SSH_AGENT_EXISTS" -eq 1 ] && [ "$SSH_SOCKET_EXISTS" -eq 0 ]; then
  rm $SSH_AUTH_SOCK 2>/dev/null
fi

# Start the ssh-agent
tmux new-session \
  -d \
  -s ssh-agent \
  ssh-agent -D -a $SSH_AUTH_SOCK \
  2>/dev/null

# Swap caps lock and escape
setxkbmap -option caps:swapescape

# Map print screen to menu
xmodmap -e "keycode 107 = Menu"

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140
