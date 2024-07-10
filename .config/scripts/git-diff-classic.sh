# Force classic red and green colours for git diff output
git -c color.diff-highlight.oldNormal='203 bold' \
    -c color.diff-highlight.oldHighlight='203 bold 52' \
    -c color.diff-highlight.newNormal='114 bold' \
    -c color.diff-highlight.newHighlight='114 bold 22' \
    -c color.diff.meta='227' \
    -c color.diff.frag='92 bold' \
    -c color.diff.commit='yellow bold' \
    -c color.diff.old='203 bold' \
    -c color.diff.new='114 bold' \
    -c color.diff.whitespace='203 reverse' \
    -c color.diff.func='98 bold' \
    diff "$@"
