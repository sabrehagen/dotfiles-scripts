#!/bin/zsh

git-log ()
{
  git log --graph --color=always --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" | \
   fzf --min-height 100 --ansi --no-sort --reverse --tiebreak=index --preview \
   'f() { set -- $(echo -- "$@" | grep -o "[a-f0-9]\{7\}"); [ $# -eq 0 ] || git show --color=always $1 ; }; f {}' \
   --bind "ctrl-j:down,ctrl-k:up,alt-j:preview-down,alt-k:preview-up,ctrl-f:preview-page-down,ctrl-b:preview-page-up,q:abort,ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % $1 | less -R') << 'FZF-EOF'
                {}
FZF-EOF" --preview-window=right:60%
}

git-log "$@"
