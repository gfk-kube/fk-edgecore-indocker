# Copyright 2018 The Kubernetes Authors.
# kind node base image
#
# For systemd + docker configuration used below, see the following references:
# https://systemd.io/CONTAINER_INTERFACE/

# start from ubuntu, this image is reasonably small as a starting point
# for a kubernetes node image, it doesn't contain much we don't need
# ARG BASE_IMAGE=ubuntu:21.10
ARG BASE_IMAGE=registry.cn-shenzhen.aliyuncs.com/infrastlabs/docker-headless:core
FROM $BASE_IMAGE as build

# RUN mkdir /kind/
# Configure crictl binary from upstream
# ARG CRICTL_URL="https://github.com/kubernetes-sigs/cri-tools/releases/download/v1.23.0/crictl-v1.23.0-linux-arm.tar.gz"

# Install dependencies, first from apt, then from release tarballs.
# NOTE: we use one RUN to minimize layers.
#
# First we must ensure that our util scripts are executable.
#
# The base image already has a basic userspace + apt but we need to install more packages.
# Packages installed are broken down into (each on a line):
# - packages needed to run services (systemd)
# - packages needed for kubernetes components
# - packages needed by the container runtime
# - misc packages kind uses itself
# - packages that provide semi-core kubernetes functionality
# After installing packages we cleanup by:
# - removing unwanted systemd services
# - disabling kmsg in journald (these log entries would be confusing)
#
# Then we install containerd from our nightly build infrastructure, as this
# build for multiple architectures and allows us to upgrade to patched releases
# more quickly.
#
# Next we download and extract crictl and CNI plugin binaries from upstream.
#
# Next we ensure the /etc/kubernetes/manifests directory exists. Normally
# a kubeadm debian / rpm package would ensure that this exists but we install
# freshly built binaries directly when we build the node image.
#
# Finally we adjust tempfiles cleanup to be 1 minute after "boot" instead of 15m
# This is plenty after we've done initial setup for a node, but before we are
# likely to try to export logs etc.

# copy in static files
# all scripts are 0755 (rwx r-x r-x)
COPY files/usr/local/bin/* /usr/local/bin/

RUN echo "Installing Packages ..." \
    && DEBIAN_FRONTEND=noninteractive clean-install \
      systemd \
      conntrack iptables iproute2 ethtool socat util-linux mount ebtables kmod \
      libseccomp2 pigz \
      bash ca-certificates curl rsync \
      nfs-common fuse-overlayfs \
      jq \
    && find /lib/systemd/system/sysinit.target.wants/ -name "systemd-tmpfiles-setup.service" -delete \
    && rm -f /lib/systemd/system/multi-user.target.wants/* \
    && rm -f /etc/systemd/system/*.wants/* \
    && rm -f /lib/systemd/system/local-fs.target.wants/* \
    && rm -f /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -f /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -f /lib/systemd/system/basic.target.wants/* \
    && echo "ReadKMsg=no" >> /etc/systemd/journald.conf 
    # && ln -s "$(which systemd)" /sbin/init


# all configs are 0644 (rw- r-- r--)
COPY files/etc/* /etc/
COPY files/etc/containerd/* /etc/containerd/
COPY files/etc/sysctl.d/* /etc/sysctl.d/
COPY files/etc/systemd/system/* /etc/systemd/system/

# bins
RUN mkdir -p /opt/cni/bin
COPY ./bins/containerd/* /usr/local/bin/
COPY ./bins/cni/cni-plugs/* /opt/cni/bin/
COPY ./bins/runc/* /usr/local/sbin/
COPY ./bins/crictl /usr/local/bin/

COPY ./bins/cni/10-containerd-net.conflist /etc/cni/net.d/
COPY ./bins/edgecore /
# COPY ./bins/edgecore.yaml /

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
    && sed -i /usr/lib/systemd/system/systemd-tmpfiles-clean.timer -e 's#OnBootSec=.*#OnBootSec=1min#' 
    # Failed to disable unit, unit udev.service does not exist.
    # && echo "Disabling udev" \
    # && systemctl disable udev.service

# squash
# FROM scratch
# COPY --from=build / /

# tell systemd that it is in docker (it will check for the container env)
# https://systemd.io/CONTAINER_INTERFACE/
ENV container docker
# systemd exits on SIGRTMIN+3, not SIGTERM (which re-executes it)
# https://bugzilla.redhat.com/show_bug.cgi?id=1201657
STOPSIGNAL SIGRTMIN+3

# NOTE: this is *only* for documentation, the entrypoint is overridden later
# ENTRYPOINT [ "/usr/local/bin/entrypoint", "/sbin/init" ]
# ENTRYPOINT [ "/lib/systemd/systemd"]
ENTRYPOINT [ "/sbin/init"]
