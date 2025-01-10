# Get the host machine public ip address
$HOME/.config/scripts/host-ssh.sh ip addr | grep 'inet ' | sed -E 's;.*inet (.*)/.*;\1;' | grep -Ev '127|172' | grep -Ev '\.1$'
