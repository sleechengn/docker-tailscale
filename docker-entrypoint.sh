#!/usr/bin/bash
tailscaled --socket $TAILSCALED_SOCKET $TAILSCALED_ARGS &

ls -la $TAILSCALED_SOCKET
while [ ! -e "$TAILSCALED_SOCKET" ]
do
	echo "=>waiting 1 second for tailscaled boot"
	sleep 1
done
ls -la $TAILSCALED_SOCKET

tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_ARGS &
tailscale --socket $TAILSCALED_SOCKET set $TAILSCALE_SET &

nohup nginx > /dev/null &
nohup filebrowser -d /opt/filebrowser/filebrowser.db -a 127.0.0.1 -p 8081 -b /filebrowser -r / --noauth > /dev/null &
ttyd --port 8082 --base-path /ttyd /usr/bin/bash
