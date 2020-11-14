export VCSH_REPO_D=$HOME/.config/vcsh/repo-private.d

# vcsh doesn't support unattended removal, so manual cleanup is required
remove_vcsh_repo() {
  REPO=$1
  echo Cleaning $REPO...

  # Remove vcsh repository tracked files
  vcsh $REPO ls-files --full-name $HOME 2>/dev/null | \
    xargs -n 1 -I file rm -rf $HOME/file 2>/dev/null

  # Remove vcsh repository tracked directories
  vcsh $REPO ls-files --full-name $HOME 2>/dev/null | \
    xargs dirname 2>/dev/null | \
    xargs -n 1 -I directory rm -rf $HOME/directory 2>/dev/null

  # Remove vcsh repository git folder
  rm -rf ~/.config/vcsh/repo-private.d/$REPO.git 2>/dev/null
}

PRIVATE_DOTFILES=$(grep dotfiles\- $HOME/.config/scripts/clone-secrets.sh | sed -E 's;.*(dotfiles-[^ ]*) .*;\1;')

for DOTFILES in $PRIVATE_DOTFILES; do
  remove_vcsh_repo $DOTFILES
done

# remove dangling id_rsa file to be replaced later
if [ -f $HOME/.ssh/id_rsa ]; then
  rm -rf $HOME/.ssh/id_rsa
fi
