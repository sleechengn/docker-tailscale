#!/usr/bin/bash
tailscaled --socket $TAILSCALED_SOCKET $TAILSCALED_DEFAULT_ARGS $TAILSCALED_ARGS &

while [ ! -e "$TAILSCALED_SOCKET" ]
do
	echo "=>waiting 1 second for tailscaled boot"
	sleep 1
done

tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_DEFAULT_WEB_ARGS &
tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_DEFAULT_SET &

nohup nginx > /dev/null &
nohup filebrowser -d /opt/filebrowser/filebrowser.db -a 127.0.0.1 -p 8081 -b /filebrowser -r / --noauth > /dev/null &
ttyd --port 8082 --base-path /ttyd /usr/bin/bash
