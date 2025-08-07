# Start the proxy if not already running
if ! netstat -tuln | grep -q 1080; then
  # Get the subnet of the host machine network
  SUBNET=$($HOME/.config/scripts/host-ssh.sh command ip route | grep default | awk '{print $3}' | cut -d'.' -f1-3)

  # Scan the subnet for the host that matches the proxy server signature
  PROXY_SERVER_IP=$(nmap -sn "$SUBNET.0/24" | grep "Nmap scan report" | grep -v '(' | awk '{print $5}')

  # Start the proxy connection
  ssh -o HostName=$PROXY_SERVER_IP proxy-server
  echo "Proxy started."
else
  echo "Proxy already running (PID $(lsof -i :1080 -t))."
fi
