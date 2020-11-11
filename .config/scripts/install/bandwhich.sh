# Install bandwhich
RUN curl -fsSL https://github.com/imsnif/bandwhich/releases/download/0.10.0/bandwhich-v0.10.0-x86_64-unknown-linux-musl.tar.gz | \
  tar -C /usr/local/bin -xzf -
