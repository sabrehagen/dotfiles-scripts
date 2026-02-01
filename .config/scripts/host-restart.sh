# Restart desktop environment on the host
exec $HOME/.config/scripts/host-ssh.sh tmux new-session -d sudo reboot now
