DESKTOP_ENVIRONMENT_LAST_MODIFIED=$(cat $HOME/repositories/sabrehagen/desktop-environment/.cachebust-dotfiles 2>/dev/null || echo 0)
DOTFILES_LAST_MODIFIED=$(vcsh foreach log -1 --date=unix --format=%cd | grep -v dotfiles | sort | tail -n 1)

if [ "$DOTFILES_LAST_MODIFIED" -ge "$DESKTOP_ENVIRONMENT_LAST_MODIFIED" ]; then
  $HOME/.config/scripts/tmux-desktop-environment-build-dotfiles.sh
fi
