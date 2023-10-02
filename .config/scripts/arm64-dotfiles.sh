ARCH=$(dpkg --print-architecture)

if [ "$ARCH" = "arm64" ]; then
  vcsh dotfiles-alacritty branch -a
  vcsh dotfiles-alacritty checkout arm64
  vcsh dotfiles-i3 checkout arm64
fi
