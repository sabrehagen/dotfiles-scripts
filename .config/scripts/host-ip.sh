# Get the host machine ip address
ip route show 0.0.0.0/0 dev eth0 | cut -d' ' -f3
