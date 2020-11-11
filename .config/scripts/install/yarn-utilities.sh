# Install yarn based utilities
RUN yarn global add \
  clipboard-cli \
  github-email \
  http-server \
  imgur-uploader-cli \
  localtunnel \
  ngrok \
  rebase-editor \
  tldr && \
  tldr --update
