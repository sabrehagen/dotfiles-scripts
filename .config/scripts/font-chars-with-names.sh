#!/bin/bash -

icons=$(echo $HOME/.local/share/uv/tools/i3-workspace-names-daemon/lib/python3.*/site-packages/fa_icons.py)

sed --quiet --regexp-extended 's/^ *"([^"]+)": u"(\\u[0-9a-f]+)",?$/\2 \1/p' $icons | while read -r char name; do
  printf '%b %s\n' $char $name
done
