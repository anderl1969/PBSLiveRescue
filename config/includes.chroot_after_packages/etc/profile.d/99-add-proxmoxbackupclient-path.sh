# add /opt/proxmoxbackupclient to path for root user
#
# all other user gets the path custumized by /etc/skel/.profile
PBC_DIR="/opt/proxmoxbackupclient"
if [ "$(id -u)" -eq 0 ] && [ -d "$PBC_DIR" ]; then
  PATH="$PATH:$PBC_DIR"
fi

export PATH
