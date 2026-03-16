# Use the first x server
export DISPLAY=:1

# Start the tmux server for daemonised services
tmux start-server

# Launch wallpaper daemon
tmux new-session \
  -d \
  -s wallpaper \
  $HOME/.config/scripts/wallpaper-daemon.sh \
  2>/dev/null

# Launch system bus
tmux new-session \
  -d \
  -s dbus-system-bus \
  sudo dbus-daemon --system --nofork --nopidfile \
  2>/dev/null

# Launch session bus
tmux new-session \
  -d \
  -s dbus-session-bus \
  dbus-daemon --session --nofork --address=unix:path=$XDG_RUNTIME_DIR/dbus-session-bus --nopidfile \
  2>/dev/null

if [ -w /dev/tty3 ]; then
  # If a physical display is attached to the container, start a hardware x server
  tmux new-session \
    -d \
    -s x11 \
    xinit -- $DISPLAY vt0$DESKTOP_ENVIRONMENT_TTY \
    2>/dev/null
else
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
    -xstartup /usr/local/bin/i3
fi

# Wait until x server is running before proceeding
if command -v xset >/dev/null; then
  until xset -q >/dev/null; do sleep 1; done
fi

# Check if secrets required for private services have been cloned
SECRETS_EXIST=$(test -d $HOME/.ssh-private; echo $?)

# Start chromium crashed session fixer
tmux new-session \
  -d \
  -s chromium-crashed-session-fixer \
  $HOME/.config/scripts/chromium-fix-crashed-session.sh \
  2>/dev/null

# Start cloudflared
if [ $SECRETS_EXIST -eq 0 ]; then
  tmux new-session \
    -d \
    -s cloudflared \
    cloudflared tunnel run \
    2>/dev/null
fi

# Start desktop environment shell
tmux new-session \
  -d \
  -s desktop-environment-shell \
  zsh --login \
  2>/dev/null

# Start dotfiles startup update
tmux new-session \
  -d \
  -s dotfiles-startup-update \
  zsh -c "vcsh list | xargs -I@ -P0 vcsh @ pull; $HOME/.config/scripts/startup.sh" \
  2>/dev/null

# Start gcsf
if [ $SECRETS_EXIST -eq 0 ]; then
  tmux new-session \
    -d \
    -s gcsf \
    gcsf mount $HOME/gdrive -s $USER \
    2>/dev/null
fi

# Start github actions runner
if [ $SECRETS_EXIST -eq 0 ]; then
  tmux new-session \
    -d \
    -s github-actions-runner \
    github-actions-runner \
    2>/dev/null
fi

# Start hotplug focusrite
tmux new-session \
  -d \
  -s hotplug-focusrite \
  $HOME/.config/scripts/hotplug-focusrite.sh \
  2>/dev/null

# Start hotplug mic
tmux new-session \
  -d \
  -s hotplug-mic \
  $HOME/.config/scripts/hotplug-mic.sh \
  2>/dev/null

# Start hotplug monitor
tmux new-session \
  -d \
  -s hotplug-monitor \
  $HOME/.config/scripts/hotplug-monitor.sh \
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

# Start ollama
if [ $SECRETS_EXIST -eq 0 ]; then
  tmux new-session \
    -d \
    -s ollama \
    ollama serve \
    2>/dev/null
fi

# Start open-webui
if [ $SECRETS_EXIST -eq 0 ]; then
  tmux new-session \
    -d \
    -s open-webui \
    ollama-webui \
    2>/dev/null
fi

# Start openvpn
if [ $SECRETS_EXIST -eq 0 ] && false; then
  tmux new-session \
    -d \
    -s openvpn \
    sudo openvpn \
    --config $HOME/.config/openvpn/default.ovpn \
    --auth-user-pass $HOME/.config/openvpn/credentials \
    --dev-node $HOME/.config/openvpn/tun \
    2>/dev/null
fi

# Start pipewire, wireplumber, pipewire-pulse
tmux new-session \
  -d \
  -s pipewire-stack \
  pipewire 2>/dev/null && \
  tmux split-window -v -t pipewire-stack pipewire-pulse && \
  tmux split-window -v -t pipewire-stack wireplumber && \
  tmux select-layout -t pipewire-stack even-vertical

# Start jackd
# tmux new-session \
#   -d \
#   -s jackd \
#   jackd -d alsa -d hw:1 -r 48000 -p 256 -n 2 \
#   2>/dev/null

# Start pulseaudio
# tmux new-session \
#   -d \
#   -s pulseaudio \
#   pulseaudio --daemonize=no \
#   2>/dev/null

# Start redshift
tmux new-session \
  -d \
  -s redshift \
  redshift -l 33.8688:151.2093 -t 6500:3600 \
  2>/dev/null

# Start screenpipe
true || tmux new-session \
  -d \
  -s screenpipe \
  screenpipe \
  2>/dev/null

# Start screenpipe ui
if [ $SECRETS_EXIST -eq 0 ]; then
  true || tmux new-session \
    -d \
    -s screenpipe-ui \
    npm --prefix /opt/screenpipe/examples/typescript/vercel-ai-chatbot run start -- --port 3003 \
    2>/dev/null
fi

# Start ssh-agent
tmux new-session \
  -d \
  -s ssh-agent \
  ssh-agent -D -a $SSH_AUTH_SOCK \
  2>/dev/null

# Start tailscale
if [ $SECRETS_EXIST -eq 0 ]; then
  # Start tailscaled
  tmux new-session \
    -d \
    -s tailscaled \
    $HOME/.local/bin/tailscaled \
    2>/dev/null

  # Join tailscale network
  $HOME/.local/bin/tailscale-up 2>/dev/null &
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

# Start unclutter
tmux new-session \
  -d \
  -s unclutter \
  unclutter \
  --ignore-scrolling \
  --not kdenlive \
  --timeout 0.15 \
  2>/dev/null

# Start vnc client
tmux new-session \
  -d \
  -s vnc-client \
  /opt/noVNC/utils/launch.sh --listen 8080 --vnc localhost:5901 \
  2>/dev/null

# Start x2x
if [ $HOSTNAME = linux ]; then
  tmux new-session \
    -d \
    -s x2x \
    $HOME/.config/x2x/start.sh \
    2>/dev/null
fi

# Take ownership of docker volumes
tmux new-session \
  -d \
  -s take-ownership \
  /opt/desktop-environment/docker/scripts/take-ownership.sh \
  2>/dev/null
