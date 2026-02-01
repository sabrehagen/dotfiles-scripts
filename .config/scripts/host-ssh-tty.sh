# Connect to host with tty and interactive shell environment
exec $HOME/.config/scripts/host-ssh.sh -t zsh -i ${@:+-c \""$@"\"}
