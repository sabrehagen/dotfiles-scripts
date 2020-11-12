# Install musikcube
wget -O musikcube.deb -nv https://github.com/clangen/musikcube/releases/download/0.90.0/musikcube_0.90.0_ubuntu_disco_amd64.deb && \
  dpkg -i musikcube.deb || apt-get install -qq --fix-broken && \
  rm musikcube.deb
