DESKTOP_ENVIRONMENT_LAST_MODIFIED=$(cat ~/repositories/sabrehagen/desktop-environment/.dotfiles-cachebust 2>/dev/null || echo 0)
DOTFILES_LAST_MODIFIED=$(vcsh foreach log -1 --date=unix --format=%cd | grep -v dotfiles | sort | tail -n 1)

if [ "$DOTFILES_LAST_MODIFIED" -ge "$DESKTOP_ENVIRONMENT_LAST_MODIFIED" ]; then
  ~/.config/scripts/tmux-desktop-environment-build-dotfiles.sh
fi
