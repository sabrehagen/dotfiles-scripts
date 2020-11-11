# Install skype
RUN wget -O skype.deb -q https://go.skype.com/skypeforlinux-64.deb && \
  dpkg -i skype.deb && \
  rm skype.deb
