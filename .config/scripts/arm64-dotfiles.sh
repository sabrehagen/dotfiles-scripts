ARCH=$(dpkg --print-architecture)

fetch_and_checkout_arm64 () { vcsh $1 fetch; vcsh $1 checkout arm64; }

if [ "$ARCH" = "arm64" ]; then
  fetch_and_checkout_arm64 dotfiles-alacritty
  fetch_and_checkout_arm64 dotfiles-i3
  fetch_and_checkout_arm64 dotfiles-x11
fi
