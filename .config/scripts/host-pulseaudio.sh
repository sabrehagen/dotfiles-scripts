# Run arguments with PULSE_SERVER set to docker host
PULSE_SERVER=$($HOME/.config/scripts/host-ip.sh) "$@"
