PRIVATE_KEY_PATH=~/.ssh/desktop-environment-host-access

# Confiture ssh client access if not already configured
if [ ! -f $PRIVATE_KEY_PATH ]; then
  ~/.config/scripts/prepare-host-ssh-access.sh
fi

# Connect to host using authorized ssh key
ssh -i $PRIVATE_KEY_PATH -t $USER@localhost "$@"
