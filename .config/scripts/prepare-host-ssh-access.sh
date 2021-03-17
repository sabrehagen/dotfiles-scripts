#!/bin/bash
PRIVATE_KEY_PATH=~/.ssh/desktop-environment-host-access

# Exit if ssh client already configured
if [ -f $PRIVATE_KEY_PATH ]; then
  exit
fi

# Prompt for user input to ensure we're running in an interactive shell
read -s -p "$USER@localhost's password: " PASSWORD

# Create client ssh private key
ssh-keygen \
  -b 2048 \
  -f $PRIVATE_KEY_PATH \
  -N '' \
  -q \
  -t rsa

# Copy public key to server's authorized_keys
ssh-copy-id -i $PRIVATE_KEY_PATH -p $PASSWORD $USER:@172.18.0.1 2>/dev/null
