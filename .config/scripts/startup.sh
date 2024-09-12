# Use the first x server
export DISPLAY=:1

# Check if secrets required for private services have been cloned
SECRETS_EXIST=$(test -d $HOME/.ssh-private; echo $?)

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
    xinit -- $DISPLAY vt0$DESKTOP_ENVIRONMENT_TTY \
    2>/dev/null
else
  # Update i3 config to use web browser compatible keybindings
  $HOME/.config/i3/set-vnc-config.sh

  # If operating in a headless server environment, start a vnc x server
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
  $HOME/.config/scripts/monitor-hotplug.sh \
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

# Start dotfiles startup update
tmux new-session \
  -d \
  -s dotfiles-startup-update \
  zsh -c "vcsh list | xargs -I@ -P0 vcsh @ pull; $HOME/.config/scripts/startup.sh" \
  2>/dev/null

# Start chromium crashed session fixer
tmux new-session \
  -d \
  -s chromium-crashed-session-fixer \
  $HOME/.config/scripts/chromium-fix-crashed-session.sh \
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
  $HOME/.config/scripts/disable-mouse.sh \
  2>/dev/null

# Start openvpn
if [ "$SECRETS_EXIST" -eq 0 ] && false; then
  tmux new-session \
    -d \
    -s openvpn \
    sudo openvpn \
    --config $HOME/.config/openvpn/default.ovpn \
    --auth-user-pass $HOME/.config/openvpn/credentials \
    --dev-node $HOME/.config/openvpn/tun \
    2>/dev/null
fi

# Start pulseaudio
tmux new-session \
  -d \
  -s pulseaudio \
  pulseaudio --daemonize=no \
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

# Start screenpipe
tmux new-session \
  -d \
  -s screenpipe \
  screenpipe \
  2>/dev/null

# Start screenpipe ui
tmux new-session \
  -d \
  -s screenpipe-ui \
  npm --prefix /opt/screenpipe/examples/typescript/vercel-ai-chatbot run start -- --port 3003 \
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
SSH_AGENT_EXISTS=$(ps aux | grep -v grep | grep -q $SSH_AUTH_SOCK; echo $?)
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

# Take ownership of docker volumes
tmux new-session \
  -d \
  -s take-ownership \
  /opt/desktop-environment/docker/scripts/take-ownership.sh \
  2>/dev/null
