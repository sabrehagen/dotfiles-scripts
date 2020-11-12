# Install jobber
wget -O jobber.deb -q https://github.com/dshearer/jobber/releases/download/v1.4.0/jobber_1.4.0-1_amd64.deb && \
  dpkg -i jobber.deb || apt-get install -qq --fix-broken && \
  rm jobber.deb
