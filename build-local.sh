#!/usr/bin/env bash
set -e

export DOCKER_BUILDKIT=1

TGT_PRX=/opt/tmp
TGT_DIR=$TGT_PRX/tailscale-build
rm -rf $TGT_DIR && mkdir -p $TGT_PRX
cp -ra $(dirname $0) $TGT_DIR

pushd $TGT_DIR
echo current $TGT_DIR
rm -rf .git

sed -i '/from debian:trixie/i\# HEAD LINE' Dockerfile
sed -i '/from debian:trixie/a\# RUN LINE' Dockerfile
sed -i 's#from debian:trixie#from 192.168.13.73:5000/debian:trixie#g' Dockerfile
sed -i '/# HEAD LINE/i\# syntax=192.168.13.73:5000/docker/dockerfile:1.3' Dockerfile
sed -i '/# RUN LINE/i\run apt update' Dockerfile
sed -i '/# RUN LINE/i\run apt install -y apt-transport-https ca-certificates' Dockerfile
sed -i '/# RUN LINE/i\run sed -i "s,http://deb.debian.org/,https://mirrors.tuna.tsinghua.edu.cn/,g" /etc/apt/sources.list.d/debian.sources' Dockerfile
sed -i '/# RUN LINE/i\run apt update' Dockerfile

#sed -i '/.*echo install source.*/d' Dockerfile
#sed -i '/.*#install source.*/i\run --mount=type=bind,target=/root/.cache,rw,source=.cache mkdir /opt/tailscale && cp /root/.cache/tailscale* /opt/tailscale && ln -s /opt/tailscale/tailscale /usr/bin/tailscale && ln -s /opt/tailscale/tailscaled /usr/bin/tailscaled' Dockerfile

time ./build.sh 192.168.13.73:5000/sleechengn/tailscale:latest
time ./build.sh sleechengn/tailscale:latest
popd

#rm -rf $TGT_DIR
docker push 192.168.13.73:5000/sleechengn/tailscale:latest
#docker push sleechengn/tailscale:latest
