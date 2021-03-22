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
eval $(find ~/.ssh-private -regextype posix-extended -regex '.*id_rsa[a-z_]*' | xargs -n1 -I@ keychain --inherit any --eval @)

# Clone private repositories using ssh key
vcsh clone git@github.com:sabrehagen/dotfiles-aws 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-cloudstorage 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-docker 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-gcloud 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-gist 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-gpg 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-irssi 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-nchat 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-nmail 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-npm 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-openvpn 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-pass 2>/dev/null &
vcsh clone git@github.com:sabrehagen/dotfiles-rescuetime 2>/dev/null &

# Wait for repositories to clone in parallel
wait

# Convert all https cloned repositories to use ssh
https_to_git () { sed -i 's;=.*://.*github.com/\(.*\);= git@github.com:\1;' "$1"; }
for REPOSITORY in $(ls -d ~/.config/vcsh/repo.d/*); do
  https_to_git $REPOSITORY/config
done

# Start services that depend on private secrets
$HOME/.config/scripts/startup.sh
