# Set wallpaper and run per-application update scripts
$HOME/.local/bin/wal -i $HOME/.local/share/wallpapers --saturate 0.3

# Reload dunst theme
$HOME/.config/dunst/wal.sh

# Reload chromium
$HOME/.config/i3/chromium-replace.sh

# Reload xava
kill -USR1 $(pgrep xava)

# Generate gtk theme
/opt/warnai/warnai --wal --gtk fantome --norender

# Reload gtk theme
gtk-theme-switch2 $HOME/.themes/warna
