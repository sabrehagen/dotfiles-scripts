# Ensure secrets are clean before cloning
$HOME/.config/scripts/clean-secrets.sh

# Store private dotfiles separately from public ones
PUBLIC_VCSH_REPOS=$HOME/.config/vcsh/repo.d
PRIVATE_VCSH_REPOS=$HOME/.config/vcsh/repo-private.d

# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f $HOME/.ssh/id_rsa ]; then
  vcshp clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh-private 2>/dev/null && \
    chmod 600 $HOME/.ssh-private/id_rsa && \
    ln -sf $HOME/.ssh/id_rsa.pub $HOME/.ssh-private/id_rsa.pub && \
    ln -sf $HOME/.ssh-private/id_rsa $HOME/.ssh/id_rsa
fi

# Unlock ssh private key so remaining repositories can be cloned
eval $(keychain --eval id_rsa)

# Make unlocked key available to tmux clients
tmux set-environment SSH_AGENT_PID $SSH_AGENT_PID
tmux set-environment SSH_AUTH_SOCK $SSH_AUTH_SOCK

# Clone private repositories using ssh key
vcshp clone git@github.com:sabrehagen/dotfiles-aws 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-docker 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-gcloud 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-gdrive 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-npm 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-onedrive 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-signal 2>/dev/null &
vcshp clone git@github.com:sabrehagen/dotfiles-wtf 2>/dev/null &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
https_to_git () { sed -i 's;https://.*github.com/\(.*\);git@github.com:\1;' "$1"; }
for REPOSITORY in $(ls -d $PUBLIC_VCSH_REPOS/* $PRIVATE_VCSH_REPOS/*); do
  https_to_git $REPOSITORY/config
done

# Load secrets into the environment
. $HOME/.zshenv

# Restart system services with secrets in the environment
$HOME/.config/scripts/startup.sh
