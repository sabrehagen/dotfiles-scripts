PRIVATE_KEY_PATH=$HOME/.ssh/desktop-environment-host-access

# Connect to host with tty and interactive shell environment
$HOME/.config/scripts/host-ssh.sh -t zsh -i ${@:+-c "$@"}
