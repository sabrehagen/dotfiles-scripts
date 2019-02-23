remove_vcsh_repo() {
  $REPO=$1

  # Remove vcsh repository tracked files
  vcsh $REPO ls-files | xargs rm -f

  # Remove vcsh repository git folder
  rm -rf ~/.config/vcsh/repo.d/$REPO
}

remove_vcsh_repo dotfiles-notes
remove_vcsh_repo dotfiles-secrets
remove_vcsh_repo dotfiles-ssh-private
