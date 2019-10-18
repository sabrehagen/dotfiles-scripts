# Start desktop environment build dotfiles
tmux new-session \
  -d \
  -s desktop-environment-build-dotfiles-$(date +%M%S) \
  ~/repositories/sabrehagen/desktop-environment/docker/scripts/build-dotfiles.sh \
  2>/dev/null
