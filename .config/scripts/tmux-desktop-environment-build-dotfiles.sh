# Kill any previous dotfiles builds
$HOME/.config/scripts/tmux-kill-desktop-environment-build-dotfiles.sh

# Start desktop environment build dotfiles
tmux new-session \
  -d \
  -s desktop-environment-build-dotfiles-$(date +%s) \
  $HOME/repositories/sabrehagen/desktop-environment/docker/scripts/build-dotfiles.sh \
  2>/dev/null
