# Install slack
wget -O slack.deb -nv https://downloads.slack-edge.com/linux_releases/slack-desktop-4.9.1-amd64.deb && \
  dpkg -i slack.deb || apt-get install -qq --fix-broken && \
  rm slack.deb
