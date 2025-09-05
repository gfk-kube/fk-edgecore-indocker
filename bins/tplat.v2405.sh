#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
# export GITHUB=https://ghproxy.com/https://github.com
export GITHUB=https://hub.yzuu.cf

function ff(){
TARGETPLATFORM=$1
URL=$2

# echo "mkdir -p $TARGETPLATFORM; cd $TARGETPLATFORM"
find
old=$(pwd); mkdir -p $TARGETPLATFORM; cd $TARGETPLATFORM
    curl -k -O -fSL $URL
    cd $old
}

: > $cur/down/.list.txt
function tplat(){
  TARGETPLATFORM=$1; URL=$2
  dest=$(echo $URL |sed "s^https://ghproxy.com/^^g" |sed "s^hub.yzuu.cf^github.com^g" \
    |sed "s^https://^^g" |sed "s^%2B^+^g") #%2B: +
  file=${dest##*/};dest=${dest%/*}; echo "destDir: $dest, file: $file"

  dst2=${cur}$WORKDIR/$TARGETPLATFORM/$dest; mkdir -p $dst2
  test -s $dst2/$file && echo "existed, skip" || curl -k -fSL -o $dst2/$file $URL
  echo $WORKDIR/$TARGETPLATFORM/$dest/$file >> $cur/down/.list.txt
}


# cfssl (只有x64的:win,nux,darwin) #https://blog.csdn.net/never_late/article/details/128570360
# # https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64
export WORKDIR=/down/down00_cfssl_x64
$RUN tplat amd64 $GITHUB/cloudflare/cfssl/releases/download/v1.6.3/cfssl_1.6.3_linux_amd64; \
  tplat amd64 $GITHUB/cloudflare/cfssl/releases/download/v1.6.3/cfssljson_1.6.3_linux_amd64; \
  tplat amd64 $GITHUB/cloudflare/cfssl/releases/download/v1.6.3/cfssl-certinfo_1.6.3_linux_amd64

export WORKDIR=/down/down01_tools
# # go:supervisord x64 10.6M; arm64 3.22M
# $RUN tplat amd64 $GITHUB/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_64-bit.tar.gz; \
#   tplat arm64 $GITHUB/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_ARM64.tar.gz
# 
# image-syncer 7.1M ##arm64: start with v131 @Oct 20, 2021
$RUN tplat amd64 $GITHUB/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-arm64.tar.gz
# registry 5.8M
$RUN tplat amd64 $GITHUB/distribution/distribution/releases/download/v2.8.1/registry_2.8.1_linux_amd64.tar.gz; \
  tplat arm64 $GITHUB/distribution/distribution/releases/download/v2.8.1/registry_2.8.1_linux_arm64.tar.gz
# 
# dcp_v2 v2.10.2@Aug 27, 2022; 24.5 MB >>  v2.11.0@Sep 14, 2022; 42.5 MB
$RUN tplat amd64 $GITHUB/docker/compose/releases/download/v2.10.2/docker-compose-linux-x86_64; \
  tplat arm64 $GITHUB/docker/compose/releases/download/v2.10.2/docker-compose-linux-aarch64



export WORKDIR=/down/down02_containerd
# containerd 1.6.15 41.4M; >> 1.6.32
$RUN \
  export VER=1.6.32; \
  tplat amd64 $GITHUB/containerd/containerd/releases/download/v${VER}/containerd-${VER}-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/containerd/containerd/releases/download/v${VER}/containerd-${VER}-linux-arm64.tar.gz
# snapshotter 1.0.5 3820k >> 1.0.8
$RUN \
  export VER=1.0.8; \
  tplat amd64 $GITHUB/containerd/fuse-overlayfs-snapshotter/releases/download/v${VER}/containerd-fuse-overlayfs-${VER}-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/containerd/fuse-overlayfs-snapshotter/releases/download/v${VER}/containerd-fuse-overlayfs-${VER}-linux-arm64.tar.gz
# cni 1.2.0 38.6M >> 1.5.0
$RUN \
  export VER=1.5.0; \
  tplat amd64 $GITHUB/containernetworking/plugins/releases/download/v${VER}/cni-plugins-linux-amd64-v${VER}.tgz; \
  tplat arm64 $GITHUB/containernetworking/plugins/releases/download/v${VER}/cni-plugins-linux-arm64-v${VER}.tgz
# runc 1.1.4 9210k>> 1.1.12
$RUN \
  export VER=1.1.12; \
  tplat amd64 $GITHUB/opencontainers/runc/releases/download/v${VER}/runc.amd64; \
  tplat arm64 $GITHUB/opencontainers/runc/releases/download/v${VER}/runc.arm64
# 23.10 +buildkit 0.12.2 >> 0.13.2
$RUN \
  export VER=0.13.2; \
  tplat amd64 $GITHUB/moby/buildkit/releases/download/v${VER}/buildkit-v${VER}.linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/moby/buildkit/releases/download/v${VER}/buildkit-v${VER}.linux-arm64.tar.gz
# 
# nerdctl 1.1.0 10.3M >> 1.7.6
#   24.7.23: v176> nerdctl-2.0.0-rc.0-linux-arm64.tar.gz ##--provenance=false
$RUN \
  export VER=2.0.0-rc.0; \
  tplat amd64 $GITHUB/containerd/nerdctl/releases/download/v${VER}/nerdctl-${VER}-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/containerd/nerdctl/releases/download/v${VER}/nerdctl-${VER}-linux-arm64.tar.gz
# crictl 1.26.0 21.8M >> 1.30.0
$RUN \
  export VER=1.30.0; \
  tplat amd64 $GITHUB/kubernetes-sigs/cri-tools/releases/download/v${VER}/crictl-v${VER}-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/kubernetes-sigs/cri-tools/releases/download/v${VER}/crictl-v${VER}-linux-arm64.tar.gz



export WORKDIR=/down/down03_k3s
# k3s 1.22.17 48.9M
$RUN \
  export VER=1.22.17; \
  tplat amd64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s; \
  tplat arm64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s-arm64
# k3s v1.23.15 58M|53M
# k3s v1.23.16 62M
# k3s v1.23.17 62M
$RUN \
  export VER=1.23.17; \
  tplat amd64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s; \
  tplat arm64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s-arm64





# 原生kubernetes: server < node < client
export WORKDIR=/down/down04_k8s
$RUN tplat amd64 https://dl.k8s.io/v1.23.17/kubernetes-server-linux-amd64.tar.gz; \
  tplat arm64 https://dl.k8s.io/v1.23.17/kubernetes-server-linux-arm64.tar.gz
# 原生kubernetes: +etcd_v354
$RUN tplat amd64 $GITHUB/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-arm64.tar.gz

# flannel v0.21.4
$RUN tplat amd64 $GITHUB/flannel-io/flannel/releases/download/v0.21.4/flannel-v0.21.4-linux-amd64.tar.gz; \
  tplat arm64 $GITHUB/flannel-io/flannel/releases/download/v0.21.4/flannel-v0.21.4-linux-arm64.tar.gz
$RUN tplat amd64 $GITHUB/flannel-io/cni-plugin/releases/download/v1.1.2/cni-plugin-flannel-linux-amd64-v1.1.2.tgz; \
  tplat arm64 $GITHUB/flannel-io/cni-plugin/releases/download/v1.1.2/cni-plugin-flannel-linux-arm64-v1.1.2.tgz


# clean
line="\n-------------------"; echo -e $line
find $cur/down -type f |sort |grep -v ".list.txt" |while read one; do
  one=$(echo $one |sed "s^$cur^^g")
  match1=$(cat $cur/down/.list.txt |grep $one)
  if [ "" == "$match1" ]; then
    one2=$(echo $one |sed "s^/down/^/down_ex/^g"); echo "mv file: $one2"
    destDir=${one2%/*}; mkdir -p ${cur}$destDir
    mv ${cur}$one ${cur}$one2;
  fi
done

# view
# $RUN cd $cur/down; ls -lh; find; tree -h;
cd $cur/
  echo -e $line; find down* -type f |sort |grep -v ".list.txt" |while read one; do ls -lh $one |awk '{print $9" "$5}'; done;
  echo -e $line; du -sh down*
  echo -e $line; du -sh down*/*
  echo -e $line; du -sh down*/*/amd64
  echo -e $line; du -sh down*/*/* |grep -v "amd64$"

# DOCKER: export DOCKER_HOST=arm64.docker.local:2375
# https://github.com/StefanScherer/docker-cli-builder
# curl -O -fSL $GITHUB/StefanScherer/docker-cli-builder/releases/download/18.09.6/docker.exe
# curl -O -fSL $GITHUB/StefanScherer/docker-cli-builder/releases/download/20.10.9/docker.exe
# KUBECTL:
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.22.md
# https://storage.googleapis.com/kubernetes-release/release/v1.22.17/kubernetes-client-windows-amd64.tar.gz
# C:\Users\Administrator\.kube\config #hosts: server.k8s.local
