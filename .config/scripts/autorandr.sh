# Apply detected monitor layout
autorandr --change

# Reload i3 to reset background image
i3-msg reload

# Respawn wallpaper daemon to match new monitor layout
tmux kill-session -t wallpaper 2>/dev/null
tmux new-session -d -s wallpaper $HOME/.config/scripts/wallpaper-daemon.sh 2>/dev/null
