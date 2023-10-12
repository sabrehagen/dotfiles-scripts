PRIVATE_KEY_PATH=$HOME/.ssh/desktop-environment-host-access

# Connect to arm64 using authorized ssh key
ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no jackson.delahunt@$($HOME/.config/scripts/arm64-ip.sh) "$@"
