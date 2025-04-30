from ubuntu:jammy
#APT_CN_UBUNTU_JAMMY
run apt update
run apt install -y curl ttyd
run echo install source && curl -fsSL https://tailscale.com/install.sh | sh
#install source
run echo "#!/usr/bin/bash" > /docker-entrypoint.sh \
	&& echo "tailscaled $TAILSCALED_ARGS &" >> /docker-entrypoint.sh \
        && echo "tailscale $TAILSCALE_ARGS &" >> /docker-entrypoint.sh \
	&& echo "/usr/bin/ttyd -p 80 /usr/bin/bash" >> /docker-entrypoint.sh \
	&& chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]
env TAILSCALED_ARGS="--socket /root/.tailscaled.sock --tun userspace-networking"
env TAILSCALE_ARGS="--socket /root/.tailscaled.sock up"
