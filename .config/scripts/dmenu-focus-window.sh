#!/bin/sh
windows=$(i3-msg -t get_tree | jq -r '.. | select(.type?) | select(.type=="con") | select(.window_properties.class) | select(.name and (.name | test("scratchpad"; "i") | not) and (.name | test("i3bar"; "i") | not)) | [.window_properties.class, .name, .id] | @tsv')
[ -z "$windows" ] && exit 0

menu_entries=$(printf '%s\n' "$windows" | awk -F '\t' '{
  cls=$1
  title=$2
  id=$3
  entry=title " | " tolower(cls)
  print entry "\t" id
}' | sort -k1,1)
[ -z "$menu_entries" ] && exit 0

selected=$(printf '%s\n' "$menu_entries" | cut -f1 | $HOME/.config/scripts/dmenu.sh -l 10)
[ -z "$selected" ] && exit 0

window_id=$(printf '%s\n' "$menu_entries" | awk -F '\t' -v name="$selected" '$1 == name {print $2; exit}')
[ -z "$window_id" ] && exit 0

i3-msg "[con_id=$window_id]" focus
