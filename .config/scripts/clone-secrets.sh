# Ensure secrets are clean before cloning
$HOME/.config/scripts/clean-secrets.sh

# Store private dotfiles separately from public ones
PUBLIC_VCSH_REPOS=$HOME/.config/vcsh/repo.d
PRIVATE_VCSH_REPOS=$HOME/.config/vcsh/repo-private.d

# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f $HOME/.ssh/id_rsa ]; then
  echo
  read -s "PASSWORD?Password for 'https://sabrehagen@github.com': "
  vcshp clone https://sabrehagen:$PASSWORD@github.com/sabrehagen/dotfiles-ssh-private && \
    chmod 600 $HOME/.ssh-private/id_rsa && \
    ln -sf $HOME/.ssh/id_rsa.pub $HOME/.ssh-private/id_rsa.pub && \
    ln -sf $HOME/.ssh-private/id_rsa $HOME/.ssh/id_rsa
fi

# Ensure ssh-agent is started so keys can be loaded
$HOME/.config/scripts/startup.sh

# Unlock ssh private key so remaining repositories can be cloned
eval $(keychain --eval id_rsa --inherit any)

# Clone private repositories using ssh key
vcshp clone git@github.com:sabrehagen/dotfiles-aws 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-cloudstorage 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-docker 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-gcloud 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-gdrive 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-gist 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-irssi 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-npm 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-onedrive 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-openvpn 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-rescuetime 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-wtf 2>/dev/null &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
https_to_git () { sed -i 's;https://.*github.com/\(.*\);git@github.com:\1;' "$1"; }
for REPOSITORY in $(ls -d $PUBLIC_VCSH_REPOS/* $PRIVATE_VCSH_REPOS/*); do
  https_to_git $REPOSITORY/config
done

# Start services that depend on private secrets
$HOME/.config/scripts/startup.sh
