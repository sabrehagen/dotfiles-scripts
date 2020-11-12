# Install dive docker image explorer
wget -q -O dive.deb https://github.com/wagoodman/dive/releases/download/v0.7.2/dive_0.7.2_linux_amd64.deb && \
  dpkg -i dive.deb && \
  rm dive.deb
