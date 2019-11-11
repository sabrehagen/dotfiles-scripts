DESKTOP_ENVIRONMENT_IMAGE_MODIFIED=$(docker inspect sabrehagen/desktop-environment --format='{{.Created}}' | xargs date +%s -d)
DOTFILES_MODIFIEDS=$(vcsh foreach log -1 --date=unix --format=%cd | grep -v dotfiles)

SHOULD_REBUILD=1

for DOTFILES_MODIFIED in $DOTFILES_MODIFIEDS; do
  if [ $DOTFILES_MODIFIED -ge $DESKTOP_ENVIRONMENT_IMAGE_MODIFIED ]; then
    SHOULD_REBUILD=0
  fi
done

if [ $SHOULD_REBUILD -eq 0 ]; then
  ~/.config/scripts/tmux-desktop-environment-build-dotfiles.sh
fi
