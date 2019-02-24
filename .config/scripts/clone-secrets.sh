# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f ~/.ssh/id_rsa ]; then
  vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh-private && \
    chmod 600 ~/.ssh/id_rsa
fi

# Unlock ssh private key so remaining repositories can be cloned
keychain --eval id_rsa

# Clone private repositories using ssh key
vcsh clone git@github.com:sabrehagen/dotfiles-notes.git &
vcsh clone git@github.com:sabrehagen/dotfiles-secrets.git &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
VCSH_REPOS=~/.config/vcsh/repo.d
for REPOSITORY in $(ls $VCSH_REPOS); do
  https-to-git $VCSH_REPOS/$REPOSITORY/config
done

# Restart system services now that secrets are available
~/.config/scripts/startup.sh
