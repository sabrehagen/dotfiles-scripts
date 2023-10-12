PRIVATE_KEY_PATH=$HOME/.ssh/desktop-environment-host-access

# Connect to host using authorized ssh key
ssh -i $PRIVATE_KEY_PATH $USER@$($HOME/.config/scripts/host-ip.sh) "$@"
