#!/bin/zsh
installerDir="$(dirname $(readlink -f $0))/install/"

program_name=$(basename $0 | sed -r 's/(.+?).sh/\1/')

(which $1 >/dev/null 2>&1)

if [ "$?" = 0 ]
then
  echo ${1}" already installed"
  exit
fi
exit

# check if upgrade arg provided
if [ -z $1 ]
then
  echo "no upgrade specified"
  exit
elif [ $1 = "-o" ]
then
  for f in $installerDir*; do echo $(basename $f | sed -r 's/(.+?).sh/\1/');
  done | column
  exit
fi


toInstall=$(${installerDir}$1)

echo $toInstall
