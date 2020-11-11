# Install novnc
RUN git clone --depth 1 https://github.com/cloud-computer/noVNC.git /opt/noVNC && \
  git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify
