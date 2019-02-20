# Remove vcsh repository contents
vcsh dotfiles-ssh-private ls-files | xargs rm -f
vcsh dotfiles-stemn ls-files | xargs rm -f

# Remove vcsh repositories
rm -rf ~/.config/vcsh/repo.d/dotfiles-ssh*
rm -rf ~/.config/vcsh/repo.d/dotfiles-stemn
