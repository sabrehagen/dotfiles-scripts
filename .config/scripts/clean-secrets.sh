# vcsh doesn't support unattended removal, so manual cleanup is required
remove_vcsh_repo() {
  REPO=$1
  echo Cleaning $REPO...

  # Remove vcsh repository tracked files
  vcsh $REPO ls-files --full-name $HOME 2>/dev/null | \
    xargs -I file rm -rf $HOME/file 2>/dev/null

  # Remove vcsh repository tracked directories
  vcsh $REPO ls-files --full-name $HOME 2>/dev/null | \
    xargs dirname 2>/dev/null | \
    xargs -I directory rm -rf $HOME/directory 2>/dev/null

  # Remove vcsh repository git folder
  rm -rf $HOME/.config/vcsh/repo.d/$REPO.git 2>/dev/null
}

PRIVATE_DOTFILES=$(grep dotfiles\- $HOME/.config/scripts/clone-secrets.sh | sed -E 's;.*(dotfiles-[^ ]*) .*;\1;')

for DOTFILES in $PRIVATE_DOTFILES; do
  remove_vcsh_repo $DOTFILES
done
