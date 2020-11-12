# Install novnc
git clone --depth 1 https://github.com/cloud-computer/noVNC.git /opt/noVNC && \
  git clone https://github.com/novnc/websockify /opt/noVNC/utils/websockify \
  sudo ln -s /opt/noVNC/utils/launch.sh /usr/local/bin/novnc
