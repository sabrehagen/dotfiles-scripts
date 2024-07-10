# Force classic red and green colours for git diff output
git -c color.diff-highlight.oldNormal='203 bold' \
    -c color.diff-highlight.oldHighlight='203 bold 52' \
    -c color.diff-highlight.newNormal='113 bold' \
    -c color.diff-highlight.newHighlight='113 bold 22' \
    -c color.diff.meta='226' \
    -c color.diff.frag='135 bold' \
    -c color.diff.commit='yellow bold' \
    -c color.diff.old='203 bold' \
    -c color.diff.new='113 bold' \
    -c color.diff.whitespace='203 reverse' \
    -c color.diff.func='146 bold' \
    diff "$@"
