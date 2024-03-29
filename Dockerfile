FROM postfinance/kubelet-csr-approver:v1.0.0 as approver
FROM dyrnq/metrics-server:v0.6.2 as metrics
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:bins-v2.4 as bins
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine-ext:weak as trans ##ERR no-arm
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/alpine as trans
# TODO image-syncer>> 复合IMG的同步;
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core as trans
  WORKDIR /down
  COPY --from=bins /down /down
  ARG TARGETPLATFORM
  ADD _trans.sh /down/
  RUN bash /down/_trans.sh; echo 1


# For systemd + docker configuration used below, see the following references:
# https://systemd.io/CONTAINER_INTERFACE/
# ARG BASE_IMAGE=ubuntu:21.10 >> headless:core multi复合img<amd64,arm64>
# TODO: 当前ali上该img是纯x64的?? >> image-sync同步multiArch
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core
FROM infrastlabs/docker-headless:core
ARG TARGETPLATFORM
# RUN mkdir /kind/
# RUN echo ${TARGETPLATFORM#*/} #不可解析

# copy in static files
# all scripts are 0755 (rwx r-x r-x)
COPY files/usr/local/bin/* /usr/local/bin/

# +bash-completion dnsutils(dig,nslookup)
RUN echo "Installing Packages ..." \
    && DEBIAN_FRONTEND=noninteractive clean-install \
      systemd \
      conntrack iptables iproute2 ethtool socat util-linux mount ebtables kmod \
      libseccomp2 pigz \
      bash ca-certificates curl rsync \
      nfs-common fuse-overlayfs \
      jq bash-completion dnsutils \
    && find /lib/systemd/system/sysinit.target.wants/ -name "systemd-tmpfiles-setup.service" -delete \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && echo "ReadKMsg=no" >> /etc/systemd/journald.conf 
    # && ln -s "$(which systemd)" /sbin/init


# bins
RUN mkdir -p /opt/cni/bin /kind/
# COPY ./bins2/amd64/containerd-1.6.15-linux-amd64/bin/* /usr/local/bin/
# COPY ./bins2/amd64/containerd-fuse-overlayfs-1.0.5-linux-amd64/containerd-fuse-overlayfs-grpc /usr/local/bin/
# COPY ./bins2/amd64/cni-plugins-linux-amd64-v1.2.0/* /opt/cni/bin/
# COPY ./bins2/amd64/runc.amd64 /usr/local/sbin/runc
# COPY ./bins2/amd64/crictl-v1.26.0-linux-amd64/crictl /usr/local/bin/
# COPY ./bins2/amd64/nerdctl-1.1.0-linux-amd64/nerdctl /usr/local/bin/docker
# COPY ./bins2/amd64/kubeedge-v1.10.3-linux-amd64/kubeedge-v1.10.3-linux-amd64/edge/edgecore /usr/local/bin/
COPY --from=trans /rootfs /
RUN \
  # 默认版本: k3s-v1.23.17 + kedge-v1.13.0
  ln -s /usr/local/bin/k3s-v1.23.17 /usr/local/bin/k3s; \
  ln -s /usr/local/kedge/kubeedge-v1.13.0-linux-*/edge/edgecore /usr/local/bin/; \
  ln -s /usr/local/kedge/kubeedge-v1.13.0-linux-*/cloud/cloudcore/cloudcore /usr/local/bin/; \
  \
  ln -s /usr/local/cfssl/cfssl_1.6.3_linux_amd64 /usr/local/bin/cfssl; \
  ln -s /usr/local/cfssl/cfssljson_1.6.3_linux_amd64 /usr/local/bin/cfssljson; \
  ln -s /usr/local/cfssl/cfssl-certinfo_1.6.3_linux_amd64 /usr/local/bin/cfssl-certinfo; \
  ln -s /usr/local/bin/docker-compose /usr/local/bin/dcp; \
  find /usr/local/bin /opt/cni/bin /usr/local/kedge/


# ref-img
COPY --from=approver /ko-app/kubelet-csr-approver /usr/local/bin/kubelet-csr-approver
COPY --from=metrics /metrics-server /usr/local/bin/metrics-server
# ee: coredns-ipin, edgecore-fix-offline-pods, nginx-v1.22.0
# TODO
# WORKDIR /down_offline_gitee
# RUN echo a.12; \
#   tplat amd64 https://gitee.com/g-k8s/fk-coredns-ipindn/releases/download/v1.8.0/coredns-x64.tar.gz; \
#   tplat arm64 https://gitee.com/g-k8s/fk-coredns-ipindn/releases/download/v1.8.0/coredns-arm64.tar.gz
# RUN tplat amd64 https://gitee.com/g-k8s/kubeedge-lite/releases/download/v1.13.0-01/edgecore-x64.tar.gz; \
#   tplat arm64 https://gitee.com/g-k8s/kubeedge-lite/releases/download/v1.13.0-01/edgecore-arm64.tar.gz
# RUN tplat amd64 https://gitee.com/g-mids/build-nginx/releases/download/v23.02.15/nginx-x64-v1.22.0.tar.gz; \
#   tplat arm64 https://gitee.com/g-mids/build-nginx/releases/download/v23.02.15/nginx-arm64-v1.22.0.tar.gz



# COPY ./files/10-containerd-net.conflist /etc/cni/net.d/
COPY ./files/bridge-nerdctl-cpout.conflist /etc/cni/net.d/
COPY ./files/edgecore-conf.yml /
# all configs are 0644 (rw- r-- r--)
# copy> add
ADD files/etc /etc

RUN echo "Installing containerd ..." \
    && rm -f /usr/local/bin/containerd-stress /usr/local/bin/containerd-shim-runc-v1 \
    && chmod 755 /usr/local/sbin/runc \
    && ctr oci spec \
        | jq '.hooks.createContainer[.hooks.createContainer| length] |= . + {"path": "/usr/local/bin/mount-product-files"}' \
        | jq 'del(.process.rlimits)' \
        > /etc/containerd/cri-base.json \
    && systemctl enable containerd
    # && containerd --version \
    # && runc --version \

RUN echo "Adjusting systemd-tmpfiles timer" \
    && sed -i /usr/lib/systemd/system/systemd-tmpfiles-clean.timer -e 's#OnBootSec=.*#OnBootSec=1min#'; \
    systemctl enable supervisor
    # Failed to disable unit, unit udev.service does not exist.
    # && echo "Disabling udev" \
    # && systemctl disable udev.service

# tell systemd that it is in docker (it will check for the container env)
# https://systemd.io/CONTAINER_INTERFACE/
ENV container docker
# systemd exits on SIGRTMIN+3, not SIGTERM (which re-executes it)
# https://bugzilla.redhat.com/show_bug.cgi?id=1201657
STOPSIGNAL SIGRTMIN+3

# NOTE: this is *only* for documentation, the entrypoint is overridden later
ENTRYPOINT [ "/usr/local/bin/entrypoint", "/sbin/init" ]
# ENTRYPOINT [ "/lib/systemd/systemd"]
# ENTRYPOINT [ "/sbin/init"]
