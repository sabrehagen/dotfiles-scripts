# Check if secrets required for private services have been cloned
SECRETS_EXIST=$(test -d ~/.config/vcsh/repo-private.d/dotfiles-openvpn.git; echo $?)

# Start the tmux server for daemonised services
tmux start-server

if [ -w /dev/tty$DESKTOP_ENVIRONMENT_HOST_TTY ]; then
  # If a physical display is attached to the container, start a hardware x server
  tmux new-session \
    -d \
    -s xserver \
    docker_run x11 \
    2>/dev/null

  # Start the x server window manager
  tmux new-session \
    -d \
    -s i3 \
    docker_run i3 \
    2>/dev/null
else
  # If operating in a server environment, start a vnc x server
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

# Start dotfiles startup update
tmux new-session \
  -d \
  -s dotfiles-startup-update \
  zsh -c "vcsh list | xargs -I@ -n1 -P0 vcsh @ pull; ~/.config/scripts/startup.sh" \
  2>/dev/null

# Start irc
if [ "$SECRETS_EXIST" -eq 0 ]; then
  tmux new-session \
    -d \
    -s irc \
    irssi \
    2>/dev/null
fi

# Start jack
tmux new-session \
  -d \
  -s jack \
  jackd -r -d alsa -r 44100 \
  2>/dev/null

# Start jobber
tmux new-session \
  -d \
  -s jobber \
  sudo /usr/lib/x86_64-linux-gnu/jobbermaster \
  2>/dev/null

# Start mouse disabler
tmux new-session \
  -d \
  -s disable-mouse \
  ~/.config/scripts/disable-mouse.sh \
  2>/dev/null

# Start musikcube
tmux new-session \
  -d \
  -s musikcube \
  musikcube \
  2>/dev/null

# Start openvpn
if [ "$SECRETS_EXIST" -eq 0 ]; then
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

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  /opt/noVNC/utils/launch.sh --listen 8080 --vnc localhost:5900 \
  2>/dev/null

# Swap caps lock and escape
setxkbmap -option caps:swapescape

# Map print screen to menu
xmodmap -e "keycode 105 = Menu"

# Enable numlock
numlockx on

# Set keyboard repeat delay and rate
xset r rate 180 140

# Force chrome to restore session on startup
sed -i 's/Crashed/normal/' ~/.config/google-chrome/Default/Preferences 2>&1 >/dev/null
