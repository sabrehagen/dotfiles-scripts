# Get the arm64 machine ip address
$HOME/.config/scripts/host-ssh.sh "ip route show 0.0.0.0/0 dev enp0s1 | sed 's/.*via \(.*\) proto.*/\1/'"
