from debian:trixie

run apt update
run apt install -y nginx curl aria2
run echo install source && curl -fsSL https://tailscale.com/install.sh | sh
#install source

run apt install -y tmux lrzsz fish

# filebrowser                                                                                                                                                                                                                                                                
run mkdir /opt/filebrowser \                                                                                                                                                                                                                                                 
        && cd /opt/filebrowser\                                                                                                                                                                                                                                              
        && DOWNLOAD=$(curl -s https://api.github.com/repos/filebrowser/filebrowser/releases/latest | grep browser_download_url |grep linux|grep amd64| grep -v rocm| cut -d'"' -f4) \                                                                                        
        && aria2c -x 10 -j 10 -k 1M ${DOWNLOAD:-https://github.com/filebrowser/filebrowser/releases/download/v2.63.15/linux-amd64-filebrowser.tar.gz} -o linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                            
        && tar -zxvf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                        
        && rm -rf linux-amd64-filebrowser.tar.gz \                                                                                                                                                                                                                           
        && ln -s $(pwd)/filebrowser /usr/bin/filebrowser

#ttyd
run set -e \
       && DOWNLOAD=$(curl -s https://api.github.com/repos/tsl0922/ttyd/releases/latest | grep browser_download_url |grep ttyd.x86_64| cut -d'"' -f4) \
       && aria2c -x 10 -j 10 -k 1m ${DOWNLOAD:-https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64} -o /usr/bin/ttyd.x86_64 \
       && chmod +x /usr/bin/ttyd.x86_64

#trzsz
run set -e \                                                                                                                                                                                                                                                                 
        && mkdir /opt/trzsz && cd /opt/trzsz \                     
        && DOWNLOAD=$(curl -s https://api.github.com/repos/trzsz/trzsz-go/releases/latest | grep browser_download_url |grep linux_x86_64|grep tar| cut -d'"' -f4) \
        && aria2c -x 10 -j 10 -k 1m $DOWNLOAD -o bin.tar.gz \
        && tar -zxvf bin.tar.gz \                                  
        && rm -rf bin.tar.gz \                                     
        && BIN_DIR=$(pwd)/$(ls -A .) \          
        && ln -s $BIN_DIR/trzsz /usr/bin/trzsz \                   
        && ln -s $BIN_DIR/trz /usr/bin/trz \                       
        && ln -s $BIN_DIR/tsz /usr/bin/tsz

run rm -rf /etc/nginx/sites-enabled/default
add ./NGINX /etc/nginx/sites-enabled/

add ./docker-entrypoint.sh /
run chmod +x /docker-entrypoint.sh
cmd []
entrypoint ["/docker-entrypoint.sh"]

env TAILSCALED_DEFAULT_ARGS="--tun userspace-networking"
env TAILSCALED_SOCKET="~/.tailscaled.sock"
env TAILSCALED_ARGS=""

env TAILSCALE_DEFAULT_SET="set --advertise-exit-node"
env TAILSCALE_DEFAULT_WEB_ARGS="web --listen 0.0.0.0:8088"
env TAILSCALE_SET=""

volume ["/root"]
volume ["/home"]
volume ["/var/lib/tailscale"]