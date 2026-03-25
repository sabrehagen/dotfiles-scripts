# Toggle classic red/green diff colours in the current shell environment.

if [ -n "$GIT_CONFIG_PARAMETERS" ]; then
  unset GIT_CONFIG_PARAMETERS
else
  export GIT_CONFIG_PARAMETERS="\
'color.diff-highlight.oldNormal=203 bold' \
'color.diff-highlight.oldHighlight=203 bold 52' \
'color.diff-highlight.newNormal=113 bold' \
'color.diff-highlight.newHighlight=113 bold 22' \
'color.diff.meta=226' \
'color.diff.frag=135 bold' \
'color.diff.commit=yellow bold' \
'color.diff.old=203 bold' \
'color.diff.new=113 bold' \
'color.diff.whitespace=203 reverse' \
'color.diff.func=146 bold'"
fi
