# Clone private ssh keys using password over https
vcsh clone https://sabrehagen@github.com/sabrehagen/dotfiles-ssh-private && \
  chmod 600 ~/.ssh/id_rsa

# Clone secrets using private key over ssh
vcsh clone git@github.com:sabrehagen/dotfiles-stemn.git
