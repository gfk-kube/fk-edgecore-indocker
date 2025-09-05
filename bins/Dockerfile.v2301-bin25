FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine-ext:weak

# 不做多arch, 直接一把包圆给到其它img使用
# ARG TARGETPLATFORM
WORKDIR /down
# test -z "$(echo $TARGETPLATFORM |grep arm)"
# RUN echo "mkdir -p \$TARGETPLATFORM; cd \$TARGETPLATFORM" > /bin/tplat; \
#   chmod +x /bin/tplat
ADD ./bins2/tplat.sh /bin/tplat
RUN chmod +x /bin/tplat

# containerd 41.4M
RUN tplat amd64 https://ghproxy.com/https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-arm64.tar.gz
# snapshotter 3820k
RUN tplat amd64 https://ghproxy.com/https://github.com/containerd/fuse-overlayfs-snapshotter/releases/download/v1.0.5/containerd-fuse-overlayfs-1.0.5-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/containerd/fuse-overlayfs-snapshotter/releases/download/v1.0.5/containerd-fuse-overlayfs-1.0.5-linux-arm64.tar.gz
# cni 38.6M
RUN tplat amd64 https://ghproxy.com/https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-amd64-v1.2.0.tgz; \
  tplat arm64 https://ghproxy.com/https://github.com/containernetworking/plugins/releases/download/v1.2.0/cni-plugins-linux-arm64-v1.2.0.tgz
# runc 9210k
RUN tplat amd64 https://ghproxy.com/https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64; \
  tplat arm64 https://ghproxy.com/https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.arm64
# 23.10 +buildkit
RUN tplat amd64 https://ghproxy.com/https://github.com/moby/buildkit/releases/download/v0.12.2/buildkit-v0.12.2.linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/moby/buildkit/releases/download/v0.12.2/buildkit-v0.12.2.linux-arm64.tar.gz

# nerdctl 10.3M
RUN tplat amd64 https://ghproxy.com/https://github.com/containerd/nerdctl/releases/download/v1.1.0/nerdctl-1.1.0-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/containerd/nerdctl/releases/download/v1.1.0/nerdctl-1.1.0-linux-arm64.tar.gz
# crictl 21.8M
RUN tplat amd64 https://ghproxy.com/https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.26.0/crictl-v1.26.0-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.26.0/crictl-v1.26.0-linux-arm64.tar.gz

# k3s 1.22.17 48.9M
RUN tplat amd64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.22.17%2Bk3s1/k3s; \
  tplat arm64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.22.17%2Bk3s1/k3s-arm64

# kedge 1.10.3 52.0M|93.7M
RUN tplat amd64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.10.3/kubeedge-v1.10.3-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.10.3/kubeedge-v1.10.3-linux-arm64.tar.gz
# kedge 1.12.1 64.6M|116M
RUN tplat amd64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.12.1/kubeedge-v1.12.1-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.12.1/kubeedge-v1.12.1-linux-arm64.tar.gz
# kedge 1.13.0 66.6M|120M
RUN tplat amd64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.13.0/kubeedge-v1.13.0-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.13.0/kubeedge-v1.13.0-linux-arm64.tar.gz

# image-syncer 7.1M ##arm64: start with v131 @Oct 20, 2021
RUN tplat amd64 https://ghproxy.com/https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-arm64.tar.gz
# registry 5.8M
RUN tplat amd64 https://ghproxy.com/https://github.com/distribution/distribution/releases/download/v2.8.1/registry_2.8.1_linux_amd64.tar.gz; \
  tplat amd64 https://ghproxy.com/https://github.com/distribution/distribution/releases/download/v2.8.1/registry_2.8.1_linux_arm64.tar.gz

# k3s v1.23.16 62M
WORKDIR /down/down_k3s_v1.23.16
RUN tplat amd64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.16%2Bk3s1/k3s; \
  tplat arm64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.16%2Bk3s1/k3s-arm64
# k3s v1.23.15 58M|53M
WORKDIR /down/down_k3s_v1.23.15
RUN tplat amd64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.15%2Bk3s1/k3s; \
  tplat arm64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.15%2Bk3s1/k3s-arm64

# cfssl (只有x64的:win,nux,darwin) #https://blog.csdn.net/never_late/article/details/128570360
# # https://github.com/cloudflare/cfssl/releases/download/v1.4.1/cfssl_1.4.1_linux_amd64
WORKDIR /down/down_cfssl_x64
RUN tplat amd64 https://ghproxy.com/https://github.com/cloudflare/cfssl/releases/download/v1.6.3/cfssl_1.6.3_linux_amd64; \
  tplat amd64 https://ghproxy.com/https://github.com/cloudflare/cfssl/releases/download/v1.6.3/cfssljson_1.6.3_linux_amd64; \
  tplat amd64 https://ghproxy.com/https://github.com/cloudflare/cfssl/releases/download/v1.6.3/cfssl-certinfo_1.6.3_linux_amd64

# dcp_v2 v2.10.2@Aug 27, 2022; 24.5 MB >>  v2.11.0@Sep 14, 2022; 42.5 MB
WORKDIR /down
RUN tplat amd64 https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-linux-x86_64; \
  tplat arm64 https://ghproxy.com/https://github.com/docker/compose/releases/download/v2.10.2/docker-compose-linux-aarch64

# go:supervisord x64 10.6M; arm64 3.22M
RUN tplat amd64 https://ghproxy.com/https://github.com/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_64-bit.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/ochinchina/supervisord/releases/download/v0.7.3/supervisord_0.7.3_Linux_ARM64.tar.gz

# kedge 1.11.2 63.5M|
# curl -O -fSL https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.11.2/kubeedge-v1.11.2-linux-amd64.tar.gz
RUN tplat amd64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.11.2/kubeedge-v1.11.2-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/kubeedge/kubeedge/releases/download/v1.11.2/kubeedge-v1.11.2-linux-arm64.tar.gz



# k3s v1.23.17 62M
WORKDIR /down/down_k3s_v1.23.17
RUN tplat amd64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.17%2Bk3s1/k3s; \
  tplat arm64 https://ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.23.17%2Bk3s1/k3s-arm64

# 原生kubernetes: server < node < client
WORKDIR /down/down_k8s_v1.23.17
RUN tplat amd64 https://dl.k8s.io/v1.23.17/kubernetes-server-linux-amd64.tar.gz; \
  tplat arm64 https://dl.k8s.io/v1.23.17/kubernetes-server-linux-arm64.tar.gz
# 原生kubernetes: +etcd_v354
RUN tplat amd64 https://ghproxy.com/https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/etcd-io/etcd/releases/download/v3.5.4/etcd-v3.5.4-linux-arm64.tar.gz

# flannel v0.21.4
RUN tplat amd64 https://ghproxy.com/https://github.com/flannel-io/flannel/releases/download/v0.21.4/flannel-v0.21.4-linux-amd64.tar.gz; \
  tplat arm64 https://ghproxy.com/https://github.com/flannel-io/flannel/releases/download/v0.21.4/flannel-v0.21.4-linux-arm64.tar.gz
RUN tplat amd64 https://ghproxy.com/https://github.com/flannel-io/cni-plugin/releases/download/v1.1.2/cni-plugin-flannel-linux-amd64-v1.1.2.tgz; \
  tplat arm64 https://ghproxy.com/https://github.com/flannel-io/cni-plugin/releases/download/v1.1.2/cni-plugin-flannel-linux-arm64-v1.1.2.tgz


RUN cd /down; ls -lh; find; tree -h;

# DOCKER: export DOCKER_HOST=arm64.docker.local:2375
# https://github.com/StefanScherer/docker-cli-builder
# curl -O -fSL https://ghproxy.com/https://github.com/StefanScherer/docker-cli-builder/releases/download/18.09.6/docker.exe
# curl -O -fSL https://ghproxy.com/https://github.com/StefanScherer/docker-cli-builder/releases/download/20.10.9/docker.exe
# KUBECTL:
# https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.22.md
# https://storage.googleapis.com/kubernetes-release/release/v1.22.17/kubernetes-client-windows-amd64.tar.gz
# C:\Users\Administrator\.kube\config #hosts: server.k8s.local
