# Exit if secrets have already been cloned
if [ -f $HOME/.ssh-private/id_rsa ]; then
  return
fi

# Ensure secrets are clean before cloning
$HOME/.config/scripts/clean-secrets.sh

# Clone private ssh keys using password over https if an ssh key is not already present
if [ ! -f $HOME/.ssh/id_rsa ]; then
  if [ -z $DESKTOP_ENVIRONMENT_GITHUB_TOKEN ]; then
    echo
    echo Login requires DESKTOP_ENVIRONMENT_GITHUB_TOKEN environment variable to be set!
    return
  fi

  vcsh clone https://sabrehagen:$DESKTOP_ENVIRONMENT_GITHUB_TOKEN@github.com/sabrehagen/dotfiles-ssh-private && \
    chmod 600 $HOME/.ssh-private/*
fi

# Unlock ssh private key so remaining repositories can be cloned
eval $(find $HOME/.ssh-private -regextype posix-extended -regex '.*id_rsa[a-z_]*' | xargs -I@ keychain --inherit any --eval @)

# Convert all https cloned repositories to use ssh
for REPOSITORY in $(ls -d $HOME/.config/vcsh/repo.d/*); do
  git_https_to_ssh $REPOSITORY/config
done

# Clone private repositories using ssh key
vcsh clone git@github.com:sabrehagen/dotfiles-aws 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-aicommit2 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-claude 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-fastfetch 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-gh 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-git-private 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-gpg 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-mopidy 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-ngrok 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-nicotine 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-op 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-openvpn 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-rescuetime 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-zsh-private 2>/dev/null &

# Wait for repositories to clone in parallel
wait

# Reload shell environment
source $HOME/.zshenv

# Start services that depend on private secrets
exec $HOME/.config/scripts/startup.sh
