#!/bin/bash -

width=80
fontfile="${1-"/usr/share/fonts/opentype/font-awesome-5/solid-thin-25.otf"}"
list="$(fc-query --format='%{charset}\n' $fontfile)"

for range in $list; do IFS=- read start end <<<"$range"
  if [ "$end" ]; then
    start=$((16#$start))
    end=$((16#$end))
    for((i=start;i<=end;i++)); do
      printf -v char '\\U%x' "$i"
      printf '%b' "$char "
    done
  else
    printf '%b' "\\U$start"
  fi
done | grep -oP '.{'"$width"'}'
