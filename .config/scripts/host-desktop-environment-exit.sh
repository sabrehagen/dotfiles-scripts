# Restart desktop environment on the host
$HOME/.config/scripts/host-ssh.sh tmux new-session -d /home/$USER/repositories/sabrehagen/desktop-environment/docker/scripts/stop.sh
