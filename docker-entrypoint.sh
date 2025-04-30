#!/usr/bin/bash
tailscaled $TAILSCALED_ARGS &
tailscale $TAILSCALE_ARGS &
ttyd -p 80 bash
