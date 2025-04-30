#!/usr/bin/bash
set -e

export DOCKER_BUILDKIT=1

TGT_PRX=/opt/tmp
TGT_DIR=$TGT_PRX/tailscale-build
rm -rf $TGT_DIR && mkdir -p $TGT_PRX
/usr/bin/cp -ra $(dirname $0) $TGT_DIR

pushd $TGT_DIR
echo current $TGT_DIR
rm -rf .git

sed -i '1i\# syntax=docker/dockerfile:1.3' Dockerfile

sed -i "/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt update" Dockerfile
sed -i "/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt install -y ca-certificates" Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN mv /etc/apt/sources.list /etc/apt/sources.list.back' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-updates main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-backports main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ jammy-security main restricted universe multiverse" >> /etc/apt/sources.list' Dockerfile
sed -i '/^#APT_CN_UBUNTU_JAMMY.*/i\RUN apt update' Dockerfile

sed -i '/.*echo install source.*/d' Dockerfile
sed -i '/.*#install source.*/i\run --mount=type=bind,target=/root/.cache,rw,source=.cache mkdir /opt/tailscale && cp /root/.cache/tailscale* /opt/tailscale && ln -s /opt/tailscale/tailscale /usr/bin/tailscale && ln -s /opt/tailscale/tailscaled /usr/bin/tailscaled' Dockerfile

time ./build.sh 192.168.13.73:5000/sleechengn/tailscale:latest
popd

#rm -rf $TGT_DIR
docker push 192.168.13.73:5000/sleechengn/tailscale:latest
