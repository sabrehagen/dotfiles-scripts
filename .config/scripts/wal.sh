# Update mpv wallpapr
WALL_CACHE=$HOME/.cache/wal
printf '{"command":["loadfile","%s","replace"]}\n' $(cat $WALL_CACHE/wal) \
  | socat - $WALL_CACHE/mpv-ipc

# Generate gtk theme
warnai --wal --gtk fantome --norender

# Reload gtk theme
gtk-theme-switch2 $HOME/.themes/warna

# Update tty, reload i3, reload gtk
wal -n -i ${1-$HOME/.local/share/wallpapers} --saturate 0.3

# Reload dunst theme
$HOME/.config/dunst/wal.sh

# Reload chromium
# $HOME/.config/i3/chromium-replace.sh

# Reload xava
kill -USR1 $(pgrep xava) 2>/dev/null
