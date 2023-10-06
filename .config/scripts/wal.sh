# Set wallpaper and run per-application update scripts
$HOME/.local/bin/wal -i $HOME/.local/share/wallpapers

# Reload dunst theme
$HOME/.config/dunst/wal.sh

# Reload xava
kill -USR1 $(pgrep xava)

# Generate gtk theme
/opt/warnai/warnai --wal --gtk fantome --norender

# Reload gtk theme
gtk-theme-switch2 $HOME/.themes/warna

# Reload vs code theme
# xdotool search --onlyvisible --class code \
#   windowactivate --sync \
#   windowfocus --sync \
#   key ctrl+shift+r
