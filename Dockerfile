from ubuntu:jammy
run apt update
run apt install -y curl ttyd
run echo install source && curl -fsSL https://tailscale.com/install.sh | sh
#install source
cmd ["-p", "80", "bash"]
entrypoint ["/usr/bin/ttyd"]
