#!/usr/bin/bash
tailscaled --socket $TAILSCALED_SOCKET $TAILSCALED_ARGS &
tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_ARGS &
tailscale --socket $TAILSCALED_SOCKET set $TAILSCALE_SET &
/usr/bin/ttyd -p 80 /usr/bin/bash
