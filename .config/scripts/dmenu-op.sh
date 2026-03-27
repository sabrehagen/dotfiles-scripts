#!/bin/sh

SESSION_FILE=$HOME/.cache/op/sessions.sh
mkdir --parents $(dirname $SESSION_FILE)
[ -f "$SESSION_FILE" ] && . "$SESSION_FILE"

level="account"
while true; do
  case $level in
    account)
      account=$(op account list --format=json | jq --raw-output '.[].shorthand' | $HOME/.config/scripts/dmenu.sh -l 5 -p "account")
      [ -z "$account" ] && exit 0
      if ! op whoami --account "$account" >/dev/null 2>&1; then
        password=$(printf '' | $HOME/.config/scripts/dmenu.sh -P -p "$account > password:")
        [ $? -eq 2 ] && continue
        [ -z "$password" ] && exit 0
        session=$(printf '%s' "$password" | op signin --raw --account "$account" 2>/dev/null)
        [ -z "$session" ] && continue
        export OP_SESSION_$account="$session"
        tmp=$(mktemp)
        grep --invert-match "OP_SESSION_$account" "$SESSION_FILE" 2>/dev/null > "$tmp" || true
        printf 'export OP_SESSION_%s=%s\n' "$account" "$session" >> "$tmp"
        mv "$tmp" "$SESSION_FILE"
      fi
      level="vault"
      ;;
    vault)
      vault=$(op vault list --account "$account" --format=json | jq --raw-output '.[].name' | $HOME/.config/scripts/dmenu.sh -l 10 -p "$account")
      [ $? -eq 2 ] && level="account" && continue
      [ -z "$vault" ] && exit 0
      level="item"
      ;;
    item)
      item=$(op item list --account "$account" --vault="$vault" --format=json | jq --raw-output '.[].title' | sort | $HOME/.config/scripts/dmenu.sh -l 18 -p "$account > $vault")
      [ $? -eq 2 ] && level="vault" && continue
      [ -z "$item" ] && exit 0
      level="field"
      ;;
    field)
      fields=$(op item get "$item" --account "$account" --vault="$vault" --format=json | jq --raw-output '
        .fields[]
        | select(.value and .value != "")
        | [(.label // .id), .value]
        | @tsv
      ')
      [ -z "$fields" ] && level="item" && continue
      selected=$(printf '%s\n' "$fields" | cut -f1 | $HOME/.config/scripts/dmenu.sh -l 10 -p "$account > $vault > $item")
      [ $? -eq 2 ] && level="item" && continue
      [ -z "$selected" ] && exit 0
      value=$(printf '%s\n' "$fields" | awk -F '\t' -v label="$selected" '$1 == label {print $2; exit}')
      [ -z "$value" ] && continue
      printf '%s' "$value" | clipboard
      exit 0
      ;;
  esac
done
