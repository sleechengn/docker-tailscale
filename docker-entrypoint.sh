#!/usr/bin/env bash

if [ -e "$TAILSCALED_SOCKET" ]; then
  rm -rf $TAILSCALED_SOCKET
fi

tailscaled --socket $TAILSCALED_SOCKET $TAILSCALED_DEFAULT_ARGS $TAILSCALED_ARGS &

while [ ! -e "$TAILSCALED_SOCKET" ]
do
	echo "=>waiting 1 second for tailscaled boot"
	sleep 1
done

tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_DEFAULT_WEB_ARGS &
tailscale --socket $TAILSCALED_SOCKET $TAILSCALE_DEFAULT_SET &

env|grep TAILSCALE_SET|while IFS='=' read -r name value
do
  echo "$value"
  if [ "$value" ]; then
    tailscale --socket $TAILSCALED_SOCKET $value
  fi
done

nohup nginx > /dev/null &
nohup filebrowser -d /opt/filebrowser/filebrowser.db -a 127.0.0.1 -p 8081 -b /filebrowser -r / --noauth > /dev/null &
if [ ! -e "~/.tmux.conf" ]; then
cat > ~/.tmux.conf <<EOF
set -g mouse on
unbind -n MouseDown3Pane
set -g default-command fish
EOF
tmux source ~/.tmux.conf
fi
if [ ! -e "/usr/bin/t" ] && [ $(id -u $(whoami)) -eq 0 ]; then
cat > /usr/bin/t <<EOF
#!/usr/bin/env bash
if [ "\$(tmux ls|grep '^default.*')" ]; then
        tmux a -t default
else
        tmux new -s default
fi
EOF
chmod +x /usr/bin/t
fi
ttyd.x86_64 --port 8082 -W -t enableZmodem=true -t enableTrzsz=true --base-path /ttyd /usr/bin/fish