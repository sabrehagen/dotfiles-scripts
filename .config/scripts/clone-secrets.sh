# Ensure secrets are clean before cloning
$HOME/.config/scripts/clean-secrets.sh

# Store private dotfiles separately from public ones
PUBLIC_VCSH_REPOS=$HOME/.config/vcsh/repo.d
PRIVATE_VCSH_REPOS=$HOME/.config/vcsh/repo-private.d
export VCSH_REPO_D=$PRIVATE_VCSH_REPOS

# Clear existing ssh sessions
keychain --stop all

# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f $HOME/.ssh/id_rsa ]; then
  vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh-private && \
    chmod 600 $HOME/.ssh-private/id_rsa
fi

# Unlock ssh private key so remaining repositories can be cloned
keychain --eval id_rsa

# Clone private repositories using ssh key
vcsh clone git@github.com:sabrehagen/dotfiles-cloudflare &
vcsh clone git@github.com:sabrehagen/dotfiles-gcloud &
vcsh clone git@github.com:sabrehagen/dotfiles-notes &
vcsh clone git@github.com:sabrehagen/dotfiles-secrets &
vcsh clone git@github.com:sabrehagen/dotfiles-signal &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
https_to_git () { sed -i 's;https://.*github.com/\(.*\);git@github.com:\1;' "$1"; }
for REPOSITORY in $(ls -d $PUBLIC_VCSH_REPOS/* $PRIVATE_VCSH_REPOS/*); do
  https_to_git $REPOSITORY/config
done

# Restart system services in a new shell with the cloned secrets
zsh -c $HOME/.config/scripts/startup.sh
