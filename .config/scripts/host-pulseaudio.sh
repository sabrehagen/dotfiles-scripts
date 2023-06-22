# Run arguments with PULSE_SERVER set to docker host
PULSE_SERVER=$(~/.config/scripts/host-ip.sh) "$@"
