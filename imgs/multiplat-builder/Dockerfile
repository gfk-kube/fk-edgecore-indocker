# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:bins-v2.5 as bins
# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core as trans
#   WORKDIR /down
#   COPY --from=bins /down /down
#   ARG TARGETPLATFORM
#   ADD _trans.sh /down/
#   RUN rm -rf /rootfs; bash /down/_trans.sh; echo 12
#   RUN \
#     rm -rf /rootfs/usr/local/kedge /rootfs/usr/local/k8s;

# FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:v2405-up2 as bins
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:v2505-up2 as bins
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core as rootfs1
  ARG TARGETPLATFORM
  WORKDIR /WS
  COPY --from=bins /down /WS/down
  ARG TARGETPLATFORM
  ADD imgs/multiplat-builder/2.loadBins.sh /WS/
  RUN echo 12; rm -rf /rootfs; export RFS=/rootfs; bash /WS/2.loadBins.sh


# FROM infrastlabs/x11-base:rootfs as perp
FROM registry.cn-shenzhen.aliyuncs.com/infrastlabs/x11-base:rootfs as perp
FROM ubuntu:20.04 as rootfs2
  COPY --from=perp /rootfs/files1/usr/local/static/perp/ /rootfs/usr/local/static/perp/
  COPY --from=perp /rootfs/files1/usr/local/static/3rd/ /rootfs/usr/local/static/3rd/
  # link
  RUN \
    rm -rf  /rootfs/usr/bin /rootfs/usr/sbin; mkdir -p /rootfs/usr/bin /rootfs/usr/sbin; \
    echo -e "\n[link] /rootfs/usr/sbin/"; \
    find /rootfs/usr/local/static -type f |grep "/sbin/" |sort | \
      while read one; do ls -lh $one; one2=$(echo $one|sed "s^/rootfs^^g"); ln -s $one2 /rootfs/usr/sbin/; done; \
    \
    echo -e "\n[link] /rootfs/usr/bin/"; \
    find /rootfs/usr/local/static -type f |grep "/bin/" |sort | \
      while read one; do ls -lh $one; one2=$(echo $one|sed "s^/rootfs^^g"); ln -s $one2 /rootfs/usr/bin/; done;

# +ref: kube-cmd> headless/core/base
FROM ubuntu:20.04
ENV \
  DEBIAN_FRONTEND=noninteractive
# mirrors.tuna.tsinghua.edu.cn #mirrors.ustc.edu.cn
# mirrors.aliyun.com #mirrors.163.com
ARG TARGETPLATFORM
RUN export DOMAIN="mirrors.ustc.edu.cn"; \
  test -z "$(echo $TARGETPLATFORM |grep arm)" && target=ubuntu || target=ubuntu-ports; \
  echo "deb http://${DOMAIN}/$target focal main restricted universe multiverse" > /etc/apt/sources.list \
  && echo "deb http://${DOMAIN}/$target focal-updates main restricted universe multiverse">> /etc/apt/sources.list; \
    \
  # default:echo -e;
  echo "path-exclude /usr/share/doc/*\n\
path-exclude /usr/share/man/*\n\
path-exclude /usr/share/locale/*\n\
path-exclude /usr/share/info/*\n\
path-exclude /usr/share/help/*\n\
path-exclude /usr/share/lintian/*\n\
" > /etc/dpkg/dpkg.cfg.d/excludes; \
  # cat /etc/dpkg/dpkg.cfg.d/excludes; \
  rm -rf /usr/share/locale/* ; \
  \
  echo 'apt update -qq && apt install -yq --no-install-recommends $@ && apt clean && rm -rf /var/lib/apt/lists/*; ' > /usr/local/bin/apt.sh \
    && chmod +x /usr/local/bin/apt.sh;
  # \
# MISC 15.1 MB
# fuse-overlayfs : Depends: fuse3 but it is not going to be installed
# dnsutils(dig,nslookup)
RUN echo skip.cache.01; \
  # \2487 kB
  apt.sh wget ca-certificates \
  # \5529 kB 
  # lame sox libsox-fmt-mp3 \
  # \4610 kB
  htop rsync tree tmux lrzsz psmisc fuse net-tools netcat iputils-ping \
  procps sudo iproute2 iptables zip unzip xz-utils vim-tiny \
  # \2476 kB
  # dropbear-bin dropbear-run openssh-sftp-server \
  curl lftp jq \
  bash-completion dnsutils git \
  gawk
# font> axin(badColorView@alpine3.13)
RUN \
  sh -c "$(wget https://gitee.com/g-system/oh-my-bash/raw/sam-custom/tools/install.sh -O -)"; \
  sed -i "s/font/axin/g" /root/.bashrc;


ENV \
  TERM=xterm \
  SHELL=/bin/bash \
  TIMEZONE=Asia/Shanghai \
  LANG=C.UTF-8
RUN \
  TIMEZONE=Asia/Shanghai; \
  ln -snf /usr/share/zoneinfo/$TIMEZONE /etc/localtime && echo $TIMEZONE > /etc/timezone; \
  #bin-link
  # mv /bin/sh /bin/busy_sh && ln -s /bin/bash /bin/sh; \
  echo "welcome! KindBox." > /etc/motd \
  && ln -s /usr/bin/vim.tiny /usr/bin/vt \
  && rm -f /bin/sh && ln -s /bin/bash /bin/sh \
  # && ln -s /usr/bin/supervisorctl /usr/bin/sv \
  && echo "alias ll='ls -lF'; alias la='ls -A'; alias l='ls -CF';" >> /root/.bashrc \
  && echo "source <(nerdctl completion bash);" >> /root/.bashrc \
  && echo "source <(nerdctl completion bash |sed \"s/nerdctl/docker/g\");" >> /root/.bashrc \
  \
  # /var/log/supervisor 
  && mkdir -p /opt/cni/bin;
  # /etc/dropbear 


# COPY --from=trans /rootfs /
# ADD files/etc /etc
# TODO: 在merge层添加: upx xxx
# ADD ./rootfs /
COPY --from=rootfs1 /rootfs /
COPY --from=rootfs2 /rootfs /
# COPY --from=rootfs1 /rootfs /rootfs1
# COPY --from=rootfs2 /rootfs /rootfs2
RUN \
  ctr -v; buildctl  -v; crictl  -v; nerdctl -v; exit 0

# #[linux/amd64 stage-4 14/14]
# #52 0.070 /bin/sh: line 1: /usr/local/bin/ctr: No such file or directory
# #57 0.116 qemu-aarch64: Could not open '/lib/ld-linux-aarch64.so.1': No such file or directory
# RUN echo "Installing containerd ..." \
#     # && rm -f /usr/local/bin/containerd-stress /usr/local/bin/containerd-shim-runc-v1 \
#     # && chmod 755 /usr/local/sbin/runc \
#     && ctr oci spec \
#         | jq '.hooks.createContainer[.hooks.createContainer| length] |= . + {"path": "/usr/local/bin/mount-product-files"}' \
#         | jq 'del(.process.rlimits)' \
#         > /etc/containerd/cri-base.json

# tell systemd that it is in docker (it will check for the container env)
# # https://systemd.io/CONTAINER_INTERFACE/
# ENV container docker

# # systemd exits on SIGRTMIN+3, not SIGTERM (which re-executes it)
# # https://bugzilla.redhat.com/show_bug.cgi?id=1201657
# STOPSIGNAL SIGRTMIN+3

# ENTRYPOINT [ "/bin/bash"]
