# vcsh doesn't support unattended removal, so manual cleanup is required
remove_vcsh_repo() {
  REPO=$1
  echo Cleaning $REPO...

  # Remove vcsh repository tracked files
  vcsh $REPO ls-files 2>/dev/null | xargs rm -f

  # Remove vcsh repository git folder
  rm -rf ~/.config/vcsh/repo-private.d/$REPO.git 2>/dev/null
}

PRIVATE_DOTFILES=$(grep dotfiles\- $HOME/.config/scripts/clone-secrets.sh | sed -E 's;.*(dotfiles-[^ ]*) .*;\1;')

for DOTFILES in $PRIVATE_DOTFILES; do
  remove_vcsh_repo $DOTFILES
done
