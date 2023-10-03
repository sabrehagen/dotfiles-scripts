# Use the first x server
export DISPLAY=:1

# Check if secrets required for private services have been cloned
SECRETS_EXIST=$(test -d ~/.ssh-private; echo $?)

# Start the tmux server for daemonised services
tmux start-server

# Start the dbus message bus
export $(dbus-launch)

# Export the dbus environment to the global tmux environment
tmux set-environment -g DBUS_SESSION_BUS_ADDRESS $DBUS_SESSION_BUS_ADDRESS
tmux set-environment -g DBUS_SESSION_BUS_PID $DBUS_SESSION_BUS_PID

if [ -w /dev/tty3 ]; then
  # If a physical display is attached to the container, start a hardware x server
  tmux new-session \
    -d \
    -s x11 \
    xinit /usr/bin/i3 -- $DISPLAY vt03 \
    2>/dev/null
else
  # Update i3 config to use web browser compatible keybindings
  ~/.config/i3/set-vnc-config.sh

  # If operating in a server environment, start a vnc x server
  tmux new-session \
    -d \
    -s vnc-server \
    vncserver $DISPLAY \
    -autokill \
    -fg \
    -geometry 1920x1080 \
    -localhost true \
    -SecurityTypes none \
    -xstartup /usr/bin/i3
fi

# Wait until x server is running before proceeding
until xset -q >/dev/null; do sleep 1; done

# Start autorandr
tmux new-session \
  -d \
  -s autorandr \
  ~/.config/scripts/monitor-hotplug.sh \
  2>/dev/null

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

# Start dunst
tmux new-session \
  -d \
  -s dunst \
  dunst \
  -print \
  2>/dev/null

# Start dotfiles startup update
tmux new-session \
  -d \
  -s dotfiles-startup-update \
  zsh -c "vcsh list | xargs -I@ -n1 -P0 vcsh @ pull; ~/.config/scripts/startup.sh" \
  2>/dev/null

# Start jobber
tmux new-session \
  -d \
  -s jobber \
  sudo $(find /usr/lib -name jobbermaster) \
  2>/dev/null

# Start mouse disabler
true || tmux new-session \
  -d \
  -s disable-mouse \
  ~/.config/scripts/disable-mouse.sh \
  2>/dev/null

# Start openvpn
if [ "$SECRETS_EXIST" -eq 0 ] && false; then
  tmux new-session \
    -d \
    -s openvpn \
    sudo openvpn \
    --config ~/.config/openvpn/default.ovpn \
    --auth-user-pass ~/.config/openvpn/credentials \
    --dev-node ~/.config/openvpn/tun \
    2>/dev/null
fi

# Start pulseaudio
tmux new-session \
  -d \
  -s pulseaudio \
  pulseaudio -D \
  2>/dev/null

# Start redshift
tmux new-session \
  -d \
  -s redshift \
  redshift -l 33.8688:151.2093 -t 6500:3600 \
  2>/dev/null

# Start rescuetime
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s rescuetime \
    rescuetime \
    2>/dev/null
fi

# Start transmission
tmux new-session \
  -d \
  -s transmission \
  transmission-daemon \
  --bind-address-ipv4 localhost \
  --config-dir ~/.config/transmission \
  --download-dir ~/torrents \
  --foreground \
  --no-auth \
  --rpc-bind-address localhost \
  --watch-dir ~/torrents/.watch \
  2>/dev/null

# Start unclutter
tmux new-session \
  -d \
  -s unclutter \
  unclutter \
  --ignore-scrolling \
  --not kdenlive \
  --timeout 0.15 \
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

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  /opt/noVNC/utils/launch.sh --listen 8080 --vnc localhost:5901 \
  2>/dev/null

# Map key modifiers
xmodmap ~/.Xmodmap

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140

# Force chrome to restore session on startup
sed -i 's/Crashed/normal/' ~/.config/google-chrome/Profile\ 1/Preferences >/dev/null 2>&1
