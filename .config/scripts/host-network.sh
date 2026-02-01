# Run gotop network graph on the host
PROCESS_NAME=${1:-gotop-net-$(date +%s | tail -c 5)}
exec $HOME/.config/scripts/host-ssh-tty.sh "set +m; echo net | ARGV0=$PROCESS_NAME gotop --layout -"
