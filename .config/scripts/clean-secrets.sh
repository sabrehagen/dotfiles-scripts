# vcsh doesn't support unattended removal, so manual cleanup is required
remove_vcsh_repo() {
  REPO=$1

  # Remove vcsh repository tracked files
  vcsh $REPO ls-files 2>/dev/null | xargs rm -f

  # Remove vcsh repository git folder
  rm -rf ~/.config/vcsh/repo-private.d/$REPO 2>/dev/null
}

remove_vcsh_repo dotfiles-cloudflare
remove_vcsh_repo dotfiles-gcloud
remove_vcsh_repo dotfiles-notes
remove_vcsh_repo dotfiles-secrets
remove_vcsh_repo dotfiles-ssh-private
