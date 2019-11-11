PRIVATE_KEY_PATH=~/.ssh/desktop-environment-host-access

# Exit if ssh client already configured
if [ -f $PRIVATE_KEY_PATH ]; then
  exit 1
fi

# Create client ssh private key
ssh-keygen \
  -b 2048 \
  -f $PRIVATE_KEY_PATH \
  -N '' \
  -q \
  -t rsa

# Copy public key to server's authorized_hosts
ssh-copy-id -i $PRIVATE_KEY_PATH $USER@localhost 2>/dev/null
