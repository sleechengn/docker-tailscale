from ubuntu:jammy
#APT_CN_UBUNTU_JAMMY
run apt update
run apt install -y curl ttyd
run echo install source && curl -fsSL https://tailscale.com/install.sh | sh
#install source
add ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
env TAILSCALED_ARGS="--socket /root/.tailscaled.sock --tun userspace-networking"
env TAILSCALE_ARGS="--socket /root/.tailscaled.sock web --listen 0.0.0.0:8088"
