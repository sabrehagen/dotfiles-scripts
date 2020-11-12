#!/bin/zsh
installerDir="$(dirname $(readlink -f $0))/install/"

# Init State Arrays
installed=()
notinstalled=()

# Get Install State
for f in $installerDir*.sh; do
  name=$(basename $f | sed -r 's/(.+?).sh/\1/')
  which $name >/dev/null 2>&1;
  if [ "$?" = 0 ]; then
    installed+=("$name")
  else
    notinstalled+=("$name")
  fi
done

# Show Install Status if no arg provided
if [ -z $1 ]; then
  echo "Installed Programs:\n"
  for p in "${installed[@]}"; do
    echo "${p}"
  done | column
  echo "\nNot Installed Programs:\n"
  for p in "${notinstalled[@]}"; do
    echo "${p}"
  done | column
  exit
fi

# Check Program already installed
if [[ ${installed[(ie)$1]} -le ${#installed} ]]; then
  echo ${1}" already installed"
  exit
fi

${installerDir}${1}.sh
