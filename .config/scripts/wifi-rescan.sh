# Rescan wifi on the host
exec $HOME/.config/scripts/host-ssh.sh nmcli dev wifi list --rescan yes
