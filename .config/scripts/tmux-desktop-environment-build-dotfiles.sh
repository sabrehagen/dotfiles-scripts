# Kill any previous dotfiles builds
$HOME/.config/scripts/tmux-kill-desktop-environment-build-dotfiles.sh

SESSION_NAME=desktop-environment-build-dotfiles-$(date +%s)

# Start desktop environment build dotfiles
tmux new-session \
  -d \
  -s $SESSION_NAME \
  zsh -c "$HOME/repositories/sabrehagen/desktop-environment/docker/scripts/build-dotfiles.sh; sleep infinity" \
  2>/dev/null

# Open a gotop host network monitor in the build session
tmux split-window -t $SESSION_NAME $HOME/.config/scripts/host-network.sh
tmux resize-pane -t ${SESSION_NAME}:1 -y 5
