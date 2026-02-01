# Restart desktop environment on the host
exec $HOME/.config/scripts/host-ssh.sh tmux new-session -d /home/$USER/repositories/sabrehagen/desktop-environment/docker/scripts/restart.sh
