PRIVATE_KEY_PATH=$HOME/.ssh/desktop-environment-host-access

# Connect to arm host using authorized ssh key
ssh -i $PRIVATE_KEY_PATH -o StrictHostKeyChecking=no jackson.delahunt@$(cat $HOME/repositories/host/macos/ip-address-bridge100) "$@"