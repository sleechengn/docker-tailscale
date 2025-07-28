from ubuntu:jammy
#APT_CN_UBUNTU_JAMMY
run apt update
run apt install -y nginx curl ttyd
run echo install source && curl -fsSL https://tailscale.com/install.sh | sh
#install source

run set -e \
	&& curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash \
        && mkdir /opt/filebrowser

run rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

add ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]

env TAILSCALED_DEFAULT_ARGS="--tun userspace-networking"
env TAILSCALED_SOCKET="/root/.tailscaled.sock"
env TAILSCALED_ARGS=""

env TAILSCALE_DEFAULT_SET="set --advertise-exit-node"
env TAILSCALE_DEFAULT_WEB_ARGS="web --listen 0.0.0.0:8088"
