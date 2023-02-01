#!/bin/bash
arch=${TARGETPLATFORM#*/}
echo "arch: $arch"

function unpack(){
old=$(pwd); cd $1
ls |grep -E ".tgz$|.tar.gz$" |while read one; do
  dir=${one%.tgz}
  dir=${dir%.tar.gz}
  echo $dir
  mkdir -p $dir; tar -zxf $one -C $dir
done
cd $old
}
unpack $arch
# unpack arm64

tree -L 2


################
mkdir -p /rootfs/usr/local/kedge /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
# ctd
\cp -a $arch/containerd-1.6.15-linux-$arch/bin/* /rootfs/usr/local/bin/
\cp -a $arch/containerd-fuse-overlayfs-1.0.5-linux-$arch/containerd-fuse-overlayfs-grpc /rootfs/usr/local/bin/
\cp -a $arch/cni-plugins-linux-$arch-v1.2.0/* /rootfs/opt/cni/bin/
\cp -a $arch/runc.$arch /rootfs/usr/local/sbin/runc
# ctd_tools
\cp -a $arch/crictl-v1.26.0-linux-$arch/crictl /rootfs/usr/local/bin/
\cp -a $arch/nerdctl-1.1.0-linux-$arch/nerdctl /rootfs/usr/local/bin/docker

# k3s,kedge
# test "amd64" == "$arch" && k3=$arch/k3s || k3=$arch/k3s-$arch ; \cp -a $k3 /rootfs/usr/local/bin/k3s
# \cp -a $arch/kubeedge-v1.10.3-linux-$arch/kubeedge-v1.10.3-linux-$arch /rootfs/usr/local/kedge/
# \cp -a $arch/kubeedge-v1.12.1-linux-$arch/kubeedge-v1.12.1-linux-$arch /rootfs/usr/local/kedge/

# v1.22.17; down_k3s_v1.23.15/
test "amd64" == "$arch" && k3=$arch/k3s || k3=$arch/k3s-$arch ; \cp -a $k3 /rootfs/usr/local/bin/k3s-v1.22.17
test "amd64" == "$arch" && k3=down_k3s_v1.23.15/$arch/k3s || k3=down_k3s_v1.23.15/$arch/k3s-$arch ; \cp -a $k3 /rootfs/usr/local/bin/k3s-v1.23.15
# kedge: x3版本
\cp -a $arch/kubeedge-v1.10.3-linux-$arch/kubeedge-v1.10.3-linux-$arch /rootfs/usr/local/kedge/
\cp -a $arch/kubeedge-v1.12.1-linux-$arch/kubeedge-v1.12.1-linux-$arch /rootfs/usr/local/kedge/
\cp -a $arch/kubeedge-v1.13.0-linux-$arch/kubeedge-v1.13.0-linux-$arch /rootfs/usr/local/kedge/

rm -f /rootfs/usr/local/bin/containerd-stress /rootfs/usr/local/bin/containerd-shim-runc-v1
chmod 755 /rootfs/usr/local/sbin/runc /rootfs/usr/local/bin/k3s 
tree /rootfs
ls -lh /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
