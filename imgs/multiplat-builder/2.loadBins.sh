#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)

function LOG(){
  echo -e "\n\n==$@ ================"
}
# 解压包##############
function unpack(){
  type1=$1; arch=$2
  old=$(pwd); cd $cur/down/$type1/$arch #|| exit 0
  if [ -d $cur/down/$type1/$arch ]; then ##exit 0, 改if判断\
  # 1. 压缩包类: 做解压
  find . -type f |grep -E ".tgz$|.tar.gz$" |while read one; do
    dir=${one%.tgz}
    dir=${dir%.tar.gz}
    dir=${dir##*/} #最后一级目录
    dst=$cur/down_${arch}_unpack/$type1.$dir
    echo "dir: $dir"
    mkdir -p $dst; tar -zxf $one -C $dst
  done
  # 2. 纯二进制程序类: 拷贝到$type.bin目录下 (dcp, cfssl, runc)
  find . -type f |grep -Ev ".tgz$|.tar.gz$" |while read one; do
    file=${one##*/} #file
    dst=$cur/down_${arch}_unpack/$type1.bin
    echo "file: $file"
    mkdir -p $dst; \cp -a $one $dst/$file; chmod +x $dst/$file
  done
  fi
  cd $old
}
# unpack amd64
# unpack arm64

test -z "$TARGETPLATFORM" && TARGETPLATFORM="linux/amd64"
arch=${TARGETPLATFORM#*/}
echo "arch: $arch"

d2=$cur/down_${arch}_unpack; sudo rm -rf $d2; mkdir -p $d2
  test "amd64" == "$arch" && unpack down00_cfssl_x64 $arch #only x64 << 未成功进入目录，导致./down上层目录全局解压;..
  unpack down01_tools $arch
  unpack down02_containerd $arch
  # unpack down03_k3s $arch
  # unpack down04_k8s $arch

# view-unpack
tree -h -L 2 $cur/down_${arch}_unpack;
tree -h $cur/down_${arch}_unpack |grep files


##rootfs 拷贝##############
test -z "$RFS" && RFS=$cur/rootfs
function copyRootfs(){
  LOG "1.准备ROOTFS目录"
  sudo rm -rf $RFS; sudo mkdir -p $RFS; sudo chmod 777 $RFS; #for none-root
  apps=$RFS/usr/local/apps
  mkdir -p $apps/{bin,cfssl,buildkit,containerd} 
  mkdir -p $RFS/opt/cni/bin/
  mkdir -p $RFS/usr/bin/

  LOG "2.拷贝文件"
  cd $cur/down_${arch}_unpack;
    # cri: ctd,fuse-overlayfs,cni,runc
    \cp -a *.containerd-*-linux-$arch/bin/* $apps/containerd/
    \cp -a *.containerd-fuse-overlayfs-*-linux-$arch/containerd-fuse-overlayfs-grpc $apps/containerd/
    rm -f $apps/containerd/containerd-stress $apps/containerd/containerd-shim-runc-v1

    # cni
    # \cp -a *.runc.$arch $apps/bin/runc
    \cp -a *.cni-plugins-linux-$arch-v*/* $RFS/opt/cni/bin/

    # cri_tools: crictl,nerdctl
    \cp -a *.crictl-v*-linux-$arch/crictl $apps/bin
    \cp -a *.nerdctl-*-linux-$arch/nerdctl $apps/bin

    # 23.10 +buildkit
    \cp -a *.buildkit-v*.linux-$arch/bin/* $apps/buildkit/

    # 23.2.4: +cfssl,dcp,gosv
    if [ "amd64" == "$arch" ]; then #只有x64版本
      \cp -a down00_cfssl_x64.bin/* $apps/cfssl/
    fi

    # bin: dcp, cfssl, runc
      #33 3.550 |-- [4.0K]  down02_containerd.bin
      #33 3.550 |   `-- [9.6M]  runc.arm64
    \cp -a *.bin/* $apps/bin/ #runc在这边拷贝了，之后link: runc.$arch -> runc
    rm -f $apps/bin/cfssl*
    # dcp rename>> 不改名?:用后面的软链做dst处理
    test "amd64" == "$arch" && file=docker-compose-linux-x86_64 || file=docker-compose-linux-aarch64; 
    mv $apps/bin/$file $apps/bin/docker-compose

    # # supervisord_static:只x64包里有
    # test "amd64" == "$arch" && file=$arch/supervisord_*_Linux_64-bit/supervisord_*_Linux_64-bit/supervisord || file=$arch/supervisord_*_Linux_ARM64/supervisord_*_Linux_ARM64/supervisord
    # \cp -a $file /rootfs/usr/local/bin/go-supervisord

    # mkdir -p /rootfs/usr/local/kedge 

  LOG "3.特定项调整"
  # 用nerdctl compose
  rm -f $apps/bin/docker-compose #清理 dcp_v2 v2.10.2@Aug 27, 2022; 24.5 MB
  touch $apps/bin/docker-compose; chmod +x $apps/bin/docker-compose;
  cat > $apps/bin/docker-compose <<EOF
#!/bin/bash
nerdctl compose \$@
EOF

  ##alter,view##############
  LOG "4.清理非执行文件"
  find $apps/ -type f |grep -E "LICENSE|Readme|README"  |while read one; do
    one=$(echo $one |sed "s^$RFS^^g");
    echo "rm file: $one"
    rm -f $cur/rootfs/$one #avoid danger rm
  done
  LOG "5.做软链接"
  find $apps/ -type f |grep -Ev "LICENSE|Readme|README" |while read one; do 
    chmod +x $one
    one=$(echo $one |sed "s^$RFS^^g");
    file=${one##*/} #file
    match1=$(echo $file |egrep "buildkit|containerd")
    if [ -z "$match1" ]; then
      file=${file%%.*} #非buildkit-qemu-$arch|containerd-fuse-overlayfs-grpc时; 去除: runc.amd64
      file=$(echo $file |sed "s^-linux^^g" |sed "s^-x86_64^^g"|sed "s^-aarch64^^g") # docker-compose-linux-x86_64
      file=${file%%_*} #cfssl-certinfo_1.6.3_linux_amd64
    fi
    echo "link: $one > rootfs/usr/bin/$file"
    ln -s $one $RFS/usr/bin/$file; 
  done
    
  sudo chown -R root:root $RFS

  tree -h $RFS
  du -sh $apps/*
}
copyRootfs
#sudo copyRootfs