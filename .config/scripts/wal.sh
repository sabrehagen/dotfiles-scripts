# Set wallpaper
~/.local/bin/wal -i ~/.local/share/wallpapers

# Reload xava
kill -USR1 $(pgrep xava)

# Generate gtk theme
/opt/warnai/warnai --wal --gtk fantome --norender

# Reload gtk theme
gtk-theme-switch2 ~/.themes/warna
