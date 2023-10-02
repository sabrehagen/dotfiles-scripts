ARCH=$(dpkg --print-architecture)

if [ "$ARCH" = "arm64" ]; then
  # handle alacritty
  vcsh dotfiles-alacritty checkout arm64

  # handle i3
  vcsh dotfiles-i3 checkout arm64
  i3-msg restart
fi
