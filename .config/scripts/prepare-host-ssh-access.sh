#!/bin/bash
PRIVATE_KEY_PATH=~/.ssh/desktop-environment-host-access

# Exit if ssh client already configured
if [ -f $PRIVATE_KEY_PATH ]; then
  exit
fi

# Prompt for user input to ensure we're running in an interactive shell
read -s -p "$USER@localhost's password: " PASSWORD

# Do not create private key if host password was not provided
if [ -z $PASSWORD ]; then
  exit
fi

# Create client ssh private key
ssh-keygen \
  -b 2048 \
  -f $PRIVATE_KEY_PATH \
  -N '' \
  -q \
  -t rsa

# Copy public key to server's authorized_keys
sshpass -p $PASSWORD ssh-copy-id -i $PRIVATE_KEY_PATH $USER@$(~/.config/scripts/host-ip.sh) 2>/dev/null
