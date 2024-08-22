# Calculate sxiv display position
X=$(xrandr | grep "*" | sed 's/x/ /g' | awk -F " " '{print $1}' | sed 's/\ //g' | head -1)
Y=$(xrandr | grep "*" | sed 's/x/ /g' | awk -F " " '{print $2}' | sed 's/\ //g' | head -1)
X1=$(echo "($X-500)/2" | bc)
Y1=$(echo "($Y-500)/2" | bc)
GEOMETRY=$(echo 500x500+$X1+$Y1)

# Show wallpaper selector
WALLPAPER=$(sxiv -t -o -r -b -g $GEOMETRY $HOME/.local/share/wallpapers | head -1)

# Set wallpaper if selected
[ -n "$WALLPAPER" ] && $HOME/.config/scripts/wal.sh $WALLPAPER
