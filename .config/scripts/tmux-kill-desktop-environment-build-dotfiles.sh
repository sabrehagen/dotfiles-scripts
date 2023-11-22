# Kill any previous dotfiles builds
tmux ls | \
  grep build-dotfiles | \
  cut -d: -f1 | \
  xargs -n1 tmux kill-session -t nonexistent-target-to-avoid-empty-build-dotfiles-session-list -t \
  2>/dev/null

# Kill any previous i3bar logs viewers
tmux kill-session -t i3bar_desktop-environment-build*
