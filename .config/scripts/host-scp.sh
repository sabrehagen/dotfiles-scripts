PRIVATE_KEY_PATH=$HOME/.ssh/desktop-environment-host-access

# Copy files to host using authorized ssh key
scp -i $PRIVATE_KEY_PATH "$1" $USER@$($HOME/.config/scripts/host-ip.sh):"$2"
