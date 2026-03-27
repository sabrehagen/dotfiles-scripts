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

_pull_repo() {
    local repo="$1"
    local old_sha
    old_sha=$(vcsh "$repo" rev-parse HEAD 2>/dev/null) || return

    # Skip repos with staged changes — autostash (rebase.autostash=true) pops without
    # --index, which silently drops the staged/unstaged distinction on restore.
    vcsh "$repo" diff --cached --quiet 2>/dev/null || return

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
        local new_sha
        new_sha=$(vcsh "$repo" rev-parse HEAD 2>/dev/null) || return
        [[ "$old_sha" == "$new_sha" ]] && return

        local body=""
        while IFS= read -r logline; do
            commit_sha="${logline%% *}"
            commit_msg="${logline#* }"
            [[ -n "$body" ]] && body+=$'\n'
            body+="${commit_sha} ${commit_msg}"

            numstat=$(vcsh "$repo" diff --numstat "${commit_sha}~1" "$commit_sha" 2>/dev/null) || numstat=""
            if [[ -n "$numstat" ]]; then
                while IFS=$'\t' read -r added deleted file; do
                    body+=$'\n'"+${added} -${deleted} ${file}"
                done <<< "$numstat"
            fi
        done < <(vcsh "$repo" log --reverse --format="%h %s" "${old_sha}..HEAD" 2>/dev/null)

        local commit_count
        commit_count=$(vcsh "$repo" rev-list --count "${old_sha}..HEAD" 2>/dev/null) || commit_count="?"
        _notify "$repo - ${commit_count} commits" "$body"
    fi
}

# Ensure control master exists so parallel pulls multiplex over one connection
if ! ssh -O check git@github.com &>/dev/null; then
    rm -f "$HOME/.ssh/cm/git@github.com:22"
    ssh -fNM git@github.com 2>/dev/null
    for _ in $(seq 50); do ssh -O check git@github.com &>/dev/null && break; sleep 0.1; done
    ssh -O check git@github.com &>/dev/null || exit 0
fi

max_jobs=10
running=0
while IFS= read -r repo; do
    _pull_repo "$repo" &
    (( ++running >= max_jobs )) && { wait -n; ((running--)); }
done < <(vcsh list)
wait
