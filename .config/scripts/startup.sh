# env config
setxkbmap -option caps:swapescape

# add ssh keys
export SSH_ASKPASS=/usr/bin/ksshaskpass
eval `ssh-agent -s`
ssh-add </dev/null
