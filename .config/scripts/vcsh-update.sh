#!/usr/bin/env bash
set -uo pipefail

# vcsh-update.sh - pull all vcsh repos and send desktop notifications
# On a successful pull: notifies with SHA, commit message, and per-file +/- stats.
# On a merge conflict:  aborts the merge (leaving no conflict markers on disk)
#                       and notifies with the repo name and git diff output.


_html_escape() { sed 's/\x1b\[[0-9;]*m//g; s/^─\+$/'"$(printf '─%.0s' {1..63})"'/; s/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g'; }

_notify() {
    local summary="$1" body="${2:-}"
    notify-send -- "$summary" "$body"
}

_notify_open() {
    local summary="$1" body="$2" && shift 2
    local files=("$@")
    # Run in background: show notification with action button, open files in code if clicked.
    (
        action=$(notify-send --action="open=Open in code" -- "$summary" "$body")
        [[ "$action" == "open" ]] && code "${files[@]}" &
    ) &
    disown 2>/dev/null || true
}

while IFS= read -r repo; do
    old_sha=$(vcsh "$repo" rev-parse HEAD 2>/dev/null) || continue

    vcsh "$repo" pull 2>&1 >/dev/null && pull_ok=true || pull_ok=false

    if [[ "$pull_ok" == "false" ]]; then
        # Detect merge conflict via porcelain status.
        conflict_files=$(vcsh "$repo" status --porcelain 2>/dev/null \
            | awk '$1 ~ /^(UU|AA|DD|AU|UA|DU|UD)$/ {print $2}') || true

        if [[ -n "$conflict_files" ]]; then
            while IFS= read -r f; do
                body=$'\n'"$(vcsh "$repo" diff -- "$f" 2>/dev/null | diff-so-fancy | _html_escape)"
                _notify_open "$repo — merge conflict: $f" "$body" "$f"
            done <<< "$conflict_files"

            vcsh "$repo" merge --abort 2>/dev/null || true
        fi
    else
        new_sha=$(vcsh "$repo" rev-parse HEAD 2>/dev/null) || continue
        [[ "$old_sha" == "$new_sha" ]] && continue

        short_sha=$(vcsh "$repo" rev-parse --short HEAD 2>/dev/null) || short_sha="${new_sha:0:7}"
        commit_msg=$(vcsh "$repo" log -1 --format="%s" 2>/dev/null) || commit_msg="(no message)"

        body="${short_sha} ${commit_msg}"

        numstat=$(vcsh "$repo" diff --numstat "$old_sha" HEAD 2>/dev/null) || numstat=""
        if [[ -n "$numstat" ]]; then
            while IFS=$'\t' read -r added deleted file; do
                body+=$'\n'"+${added} -${deleted} ${file}"
            done <<< "$numstat"
        fi

        _notify "$repo" "$body"
    fi
done < <(vcsh list)
