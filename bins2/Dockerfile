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

RUN ls -lh; find; tree -h;
