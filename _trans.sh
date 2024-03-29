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
# WORKDIR /down
cd /down/down_k8s_v1.23.17; unpack $arch
cd /down; unpack $arch #xx.tar.gz all in /down/
# cd /down/down_gitee; unpack $arch
# unpack arm64

tree -L 2


################
cd /down;
mkdir -p /rootfs/usr/local/cfssl /rootfs/usr/local/kedge /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
# cri: ctd,fuse-overlayfs,cni,runc
\cp -a $arch/containerd-1.6.15-linux-$arch/bin/* /rootfs/usr/local/bin/
\cp -a $arch/containerd-fuse-overlayfs-1.0.5-linux-$arch/containerd-fuse-overlayfs-grpc /rootfs/usr/local/bin/
\cp -a $arch/cni-plugins-linux-$arch-v1.2.0/* /rootfs/opt/cni/bin/
\cp -a $arch/runc.$arch /rootfs/usr/local/sbin/runc
# cri_tools: crictl,nerdctl
\cp -a $arch/crictl-v1.26.0-linux-$arch/crictl /rootfs/usr/local/bin/
\cp -a $arch/nerdctl-1.1.0-linux-$arch/nerdctl /rootfs/usr/local/bin/docker
# 23.10 +buildkit
\cp -a $arch/buildkit-v0.12.2.linux-$arch/bin/* /rootfs/usr/local/bin/

# 23.2.4: +cfssl,dcp,gosv
if [ "amd64" == "$arch" ]; then #只有x64版本
  \cp -a down_cfssl_x64/$arch/cfssl_1.6.3_linux_amd64 /rootfs/usr/local/cfssl/
  \cp -a down_cfssl_x64/$arch/cfssljson_1.6.3_linux_amd64 /rootfs/usr/local/cfssl/
  \cp -a down_cfssl_x64/$arch/cfssl-certinfo_1.6.3_linux_amd64 /rootfs/usr/local/cfssl/
  chmod +x /rootfs/usr/local/cfssl/cfssl*
fi
test "amd64" == "$arch" && file=$arch/docker-compose-linux-x86_64 || file=$arch/docker-compose-linux-aarch64; 
\cp -a $file /rootfs/usr/local/bin/docker-compose #rename, link dcp @Dockerfile
# supervisord_static:只x64包里有
test "amd64" == "$arch" && file=$arch/supervisord_0.7.3_Linux_64-bit/supervisord_0.7.3_Linux_64-bit/supervisord || file=$arch/supervisord_0.7.3_Linux_ARM64/supervisord_0.7.3_Linux_ARM64/supervisord
\cp -a $file /rootfs/usr/local/bin/go-supervisord
chmod +x /rootfs/usr/local/bin/*


# k8s,k3s,kedge
# k8s (_ex_bin:597M; bin:475M>pack126M;)
old=$(pwd); cd down_k8s_v1.23.17/$arch/kubernetes-server-linux-$arch/kubernetes/server/bin
  rm -rf ../LICENSES; mkdir -p ../_ex_bin/
  mv *.tar *docker_tag ../_ex_bin/
  mv mounter kubectl-convert kubeadm kube-log-runner  kube-aggregator  apiextensions-apiserver ../_ex_bin/
  du -sh ../*; find ../; tree -h ../ #view
  mkdir -p /rootfs/usr/local/k8s/server/bin/; \cp -a * /rootfs/usr/local/k8s/server/bin/
cd $old
# etcd 23M,etcdctl 18M, --etcdutl 16M
mkdir -p /rootfs/usr/local/k8s/etcd/bin/; 
\cp -a down_k8s_v1.23.17/$arch/etcd-v3.5.4-linux-$arch/etcd-v3.5.4-linux-$arch/etcd /rootfs/usr/local/k8s/etcd/bin/
\cp -a down_k8s_v1.23.17/$arch/etcd-v3.5.4-linux-$arch/etcd-v3.5.4-linux-$arch/etcdctl /rootfs/usr/local/k8s/etcd/bin/
# flanneld/flannel 11M: flannel-v0.21.4-linux-arm64
mkdir -p /rootfs/usr/local/k8s/cni/bin/; 
\cp -a down_k8s_v1.23.17/$arch/flannel-v0.21.4-linux-$arch/flanneld /rootfs/usr/local/k8s/cni/bin/
# cni-plugin-flannel-linux-$arch-v1.1.2/flannel-$arch
\cp -a down_k8s_v1.23.17/$arch/cni-plugin-flannel-linux-$arch-v1.1.2/flannel-$arch /rootfs/usr/local/k8s/cni/bin/flannel


# k3s: v1.22.17; down_k3s_v1.23.17/
# test "amd64" == "$arch" && k3=$arch/k3s || k3=$arch/k3s-$arch ; \cp -a $k3 /rootfs/usr/local/bin/k3s-v1.22.17
test "amd64" == "$arch" && k3=down_k3s_v1.23.17/$arch/k3s || k3=down_k3s_v1.23.17/$arch/k3s-$arch ; \cp -a $k3 /rootfs/usr/local/bin/k3s-v1.23.17

# kedge: x3版本
# \cp -a $arch/kubeedge-v1.10.3-linux-$arch/kubeedge-v1.10.3-linux-$arch /rootfs/usr/local/kedge/
# \cp -a $arch/kubeedge-v1.11.2-linux-$arch/kubeedge-v1.11.2-linux-$arch /rootfs/usr/local/kedge/
# \cp -a $arch/kubeedge-v1.12.1-linux-$arch/kubeedge-v1.12.1-linux-$arch /rootfs/usr/local/kedge/
\cp -a $arch/kubeedge-v1.13.0-linux-$arch/kubeedge-v1.13.0-linux-$arch /rootfs/usr/local/kedge/
# clear kedge
  # cloud/admission/admission
  # cloud/controllermanager/controllermanager
  # cloud/csidriver/csidriver
  # cloud/iptablesmanager/iptablesmanager
  # version
du -sh /rootfs/usr/local/kedge/
find /rootfs/usr/local/kedge/ -type f |grep -Ev "cloudcore|edgecore" |sort |xargs rm -rf
du -sh /rootfs/usr/local/kedge/

# ee: coredns-ipin, edgecore-fix-offline-pods
# TODO: mv /Dockerfile
# # https://gitee.com/g-k8s/fk-coredns-ipindn/releases/tag/v1.8.0
# # https://gitee.com/g-k8s/kubeedge-lite/releases/tag/v1.13.0-01
# arch2=$arch; test "amd64" == "$arch" && arch2="x64"
# # coredns
# \cp -a down_gitee/$arch/coredns-$arch2/coredns-$arch2 /rootfs/usr/local/bin/coredns
# # edgecore
# mv /rootfs/usr/local/kedge/kubeedge-v1.13.0-linux-amd64/edge/edgecore \
#  /rootfs/usr/local/kedge/kubeedge-v1.13.0-linux-amd64/edge/edgecore-org
# \cp -a down_gitee/$arch/edgecore-$arch2/edgecore-$arch2 /rootfs/usr/local/kedge/kubeedge-v1.13.0-linux-amd64/edge/edgecore

# alter,view
rm -f /rootfs/usr/local/bin/containerd-stress /rootfs/usr/local/bin/containerd-shim-runc-v1
chmod 755 /rootfs/usr/local/sbin/runc /rootfs/usr/local/bin/k3s*
tree -h /rootfs
ls -lh /rootfs/usr/local/bin/ /rootfs/usr/local/sbin/ /rootfs/opt/cni/bin/
