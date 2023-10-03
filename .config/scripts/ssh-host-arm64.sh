PRIVATE_KEY_PATH=~/.ssh/desktop-environment-host-access

# Connect to arm host using authorized ssh key
ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no jackson.delahunt@$(cat ~/repositories/host/macos/ip-address-bridge100) "$@"
