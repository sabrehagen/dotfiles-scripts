# Set wallpaper and run per-application update scripts
~/.local/bin/wal -i ~/.local/share/wallpapers

# Reload dunst theme
~/.config/dunst/wal.sh &

# Reload xava
kill -USR1 $(pgrep xava) &

# Generate gtk theme
/opt/warnai/warnai --wal --gtk fantome --norender &

# Reload gtk theme
gtk-theme-switch2 ~/.themes/warna &

# Reload vs code theme
# xdotool search --onlyvisible --class code \
#   windowactivate --sync \
#   windowfocus --sync \
#   key ctrl+shift+r &

# Wait for themes to update in parallel
wait
