#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
# v2405: ff手动构建? (其内为旧版ctd1.6.15; 及其它misc-ver)
# v2405-up1: ../../bins2/imgbuild.sh中指定生成
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:v2405-up1 #bins-v2.3
docker pull $img

# ok: oldRef
# docker run --rm -v /usr/local/bin:/mnt $repo/k-bin/sync-kube:kube-att sh -c 'cp -a /down/docker-compose /mnt/'
# ERR: (有空格就断开了)
# docker run -it --rm -v $(pwd):/mnt $img sh -c "pwd; cp -a /down/* /mnt/"

# 挂载，拷贝文件##############
touch $cur/_outhere.sh; chmod +x $cur/_outhere.sh
cat >$cur/_outhere.sh <<EOF
#!/bin/bash
cur=\$(cd "\$(dirname "\$0")"; pwd)

# docker run --rm -it -v \$(pwd):/mnt \$img  /mnt/_outhere.sh
tree -h /down/ |grep files
chmod 777 /down/* ##out-headless-write
cd \$cur
  echo "copying, wait.."
  \cp -a /down/. ./down/ #. with dots
  du -sh *
EOF
d2=$cur/down; sudo rm -rf $d2; mkdir -p $d2
docker run --rm -it -v $(pwd):/mnt $img  /mnt/_outhere.sh

# exit 0