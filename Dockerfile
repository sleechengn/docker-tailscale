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

env TAILSCALED_ARGS="--tun userspace-networking"
env TAILSCALED_SOCKET="/root/.tailscaled.sock"
env TAILSCALE_SET="--advertise-exit-node"
env TAILSCALE_ARGS="web --listen 0.0.0.0:8088"
