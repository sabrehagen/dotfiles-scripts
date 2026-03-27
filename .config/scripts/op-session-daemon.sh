#!/bin/sh

SESSION_FILE=$HOME/.cache/op/sessions.sh
REFRESH_INTERVAL=1500

log() {
  printf '[%s] %s\n' "$(date '+%Y-%m-%d %H:%M:%S')" "$*"
}

log "op-session-daemon started"

while true; do
  [ -f "$SESSION_FILE" ] && . "$SESSION_FILE"

  accounts=$(op account list --format=json 2>/dev/null)
  if [ -z "$accounts" ]; then
    log "no accounts found, retrying"
    sleep 5
    continue
  fi

  printf '%s\n' "$accounts" | jq --raw-output '.[].shorthand' | while read -r shorthand; do
    eval current_token=\$OP_SESSION_$shorthand
    if [ -z "$current_token" ] || ! OP_SESSION_$shorthand="$current_token" op whoami --account "$shorthand" >/dev/null 2>&1; then
      log "$shorthand: no active session, skipping"
      continue
    fi

    log "$shorthand: keepalive ok, next in ${REFRESH_INTERVAL}s"
  done

  sleep $REFRESH_INTERVAL
done
