# Install cmatrix
apt-get install -qq libncurses5-dev && \
  git clone --depth 1 https://github.com/abishekvashok/cmatrix && \
  mkdir -p cmatrix/build && \
  cd cmatrix/build && \
  cmake .. && \
  make && \
  make install
