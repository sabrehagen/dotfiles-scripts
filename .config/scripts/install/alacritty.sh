# Install alacritty
RUN wget -O alacritty.deb -nv https://github.com/jwilm/alacritty/releases/download/v0.3.3/Alacritty-v0.3.3-ubuntu_18_04_amd64.deb && \
  dpkg -i alacritty.deb && \
  rm alacritty.deb
