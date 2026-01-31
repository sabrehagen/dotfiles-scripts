# Kill any previous desktop environment builds
$HOME/.config/scripts/tmux-kill-desktop-environment-build.sh

SESSION_NAME=desktop-environment-build-dotfiles-$(date +%s)

# Start desktop environment build dotfiles
tmux new-session \
  -d \
  -s $SESSION_NAME \
  zsh -c "\
    $HOME/repositories/sabrehagen/desktop-environment/docker/scripts/build-dotfiles.sh; \
    $HOME/.config/scripts/host-ssh.sh pkill -STOP -x $SESSION_NAME; \
    sleep infinity \
  " \
  2>/dev/null

# Open a gotop host network monitor in the build session
tmux split-window -t $SESSION_NAME zsh -c "$HOME/.config/scripts/host-network.sh $SESSION_NAME; sleep infinity"
tmux resize-pane -t $SESSION_NAME:1 -y 5
