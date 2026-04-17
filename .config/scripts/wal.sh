# Generate pywal colors from wallpaper
wal -n -i ${1-$HOME/.local/share/wallpapers} --saturate 0.3

# Generate gtk theme from pywal colors
warnai --wal --gtk fantome --norender

# Reload gtk2 theme
gtk-theme-switch2 $HOME/.themes/warna

# Reload gtk3 theme by simulating theme name change
THEME_NAME=warna-$(date +%N)
ln -s warna $HOME/.themes/$THEME_NAME
sed -i "s;Net/ThemeName .*;Net/ThemeName \"$THEME_NAME\";" $HOME/.xsettingsd
pkill -HUP xsettingsd

# Update mpv wallpapr
echo '{"command":["loadfile","'"$(cat $HOME/.cache/wal/wal)"'","replace"]}' | socat - $HOME/.cache/wal/mpv-ipc

# Update telegram theme
walogram

# Reload dunst theme
$HOME/.config/dunst/wal.sh

# Reload chromium
# $HOME/.config/i3/chromium-replace.sh

# Reload xava
pkill -USR1 xava 2>/dev/null
