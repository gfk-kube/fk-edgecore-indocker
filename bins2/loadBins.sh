#!/bin/bash

img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:bins-v2.3
docker pull $img

# ok: oldRef
# docker run --rm -v /usr/local/bin:/mnt $repo/k-bin/sync-kube:kube-att sh -c 'cp -a /down/docker-compose /mnt/'
# ERR: (有空格就断开了)
# docker run -it --rm -v $(pwd):/mnt $img sh -c "pwd; cp -a /down/* /mnt/"

# 直接执行文件
docker run --rm -it -v $(pwd):/mnt $img  /mnt/_outhere.sh

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
# unpack amd64
# unpack arm64

tree -L 2