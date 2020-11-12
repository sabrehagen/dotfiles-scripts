# Install xava
apt-get update -qq && \
  apt-get install -qq \
  libfftw3-dev \
  libasound2-dev \
  libpulse-dev \
  libx11-dev \
  libsdl2-dev && \
  git clone --depth 1 https://github.com/sabrehagen/xava && \
  git clone --depth 1 https://github.com/ndevilla/iniparser xava/lib/iniparser && \
  mkdir xava/build && \
  cd xava/build && \
  cmake .. -DCMAKE_BUILD_TYPE=Debug -DINCLUDE_DIRS=lib/iniparser/src && \
  make -j$(nproc) && \
  make install
