# check if upgrade arg provided
if [ -z $1 ]
then
  echo "no upgrade specified"
  exit
fi

installerDir=$(dirname $(readlink -f $0))/install/

toInstall=$(${installerDir}$1)

echo $toInstall
