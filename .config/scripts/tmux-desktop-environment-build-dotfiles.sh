# Kill any previous dotfiles builds
tmux ls | \
  grep build-dotfiles | \
  cut -f1 -d: | \
  xargs -n1 tmux kill-session -t \
  2>/dev/null

# Start desktop environment build dotfiles
tmux new-session \
  -d \
  -s desktop-environment-build-dotfiles-$(date +%s) \
  ~/repositories/sabrehagen/desktop-environment/docker/scripts/build-dotfiles.sh \
  2>/dev/null
