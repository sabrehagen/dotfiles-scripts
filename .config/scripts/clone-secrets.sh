# Ensure secrets are clean before cloning
$HOME/.config/scripts/clean-secrets.sh

# Store private dotfiles separately from public ones
PUBLIC_VCSH_REPOS=$HOME/.config/vcsh/repo.d
PRIVATE_VCSH_REPOS=$HOME/.config/vcsh/repo-private.d
export VCSH_REPO_D=$PRIVATE_VCSH_REPOS

# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f $HOME/.ssh/id_rsa ]; then
  vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh-private && \
    chmod 600 $HOME/.ssh/id_rsa
fi

# Unlock ssh private key so remaining repositories can be cloned
keychain --eval id_rsa

# Clone private repositories using ssh key
vcsh clone git@github.com:sabrehagen/dotfiles-cloudflare.git &
vcsh clone git@github.com:sabrehagen/dotfiles-gcloud.git &
vcsh clone git@github.com:sabrehagen/dotfiles-notes.git &
vcsh clone git@github.com:sabrehagen/dotfiles-secrets.git &
vcsh clone git@github.com:sabrehagen/dotfiles-signal.git &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
https_to_git () { sed -i 's;https://.*github.com/\(.*\);git@github.com:\1;' "$1"; }
for REPOSITORY in $(ls -d $PUBLIC_VCSH_REPOS/* $PRIVATE_VCSH_REPOS/*); do
  https_to_git $REPOSITORY/config
done

# Load the secrets into the environment
source $HOME/.zshenv

# Restart system services now that secrets are available
$HOME/.config/scripts/startup.sh
