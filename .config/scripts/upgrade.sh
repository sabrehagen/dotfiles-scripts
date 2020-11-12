installerDir="$(dirname $(readlink -f $0))/install/"

#array=(*)
#echo "${array[2]}"

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
