# Install cool retro term
RUN add-apt-repository ppa:vantuz/cool-retro-term && \
  apt-get update -qq && \
  apt-get install -qq cool-retro-term
