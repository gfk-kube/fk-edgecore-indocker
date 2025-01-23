#!/bin/bash
cur=$(dirname $(readlink -f "$0"))
cd $cur


test -z "$SYNC_ALI"  && SYNC_ALI=false
test -z "$SYNC_LIST" && SYNC_LIST="src.txt"
test -z "$SYNC_ARCH" && SYNC_ARCH="amd64,arm64"
# 
test -z "$ALI_URL"   && ALI_URL="registry.cn-shenzhen.aliyuncs.com"
test -z "$ALI_IMG"   && ALI_IMG="infrasync/v2025"
test -z "$LOCAL_URL" && LOCAL_URL="server.k8s.local:18443"
test -z "$LOCAL_IP"  && LOCAL_IP="172.25.21.60"
# test -z "$SYNC_LIST" && errExit "please with src.txt"

function errExit(){
  echo "ERR: $1"
  exit 1
}

# auth: hub仓,ali仓,本地仓
function authConf(){
  # hosts
  LOCAL_URL2=${LOCAL_URL%:*}
  cat /etc/hosts |grep -V $LOCAL_URL2 /tmp/hosts;  echo "$LOCAL_IP $LOCAL_URL2" >> /tmp/hosts
  cat /tmp/hosts |sudo tee /etc/hosts; cat /etc/hosts |grep "$LOCAL_URL2" #view

  # $authyml
  authyml=/tmp/auth.yml; cat auth.yml > $authyml
  # +replaceAcc
  # hub
  sed -i "s/username: .*#hub/username: ${DOCKER_REGISTRY_USER_dockerhub} #hub/g" $authyml
  sed -i "s/password: .*#hub/password: ${DOCKER_REGISTRY_PW_dockerhub} #hub/g" $authyml
  # ali
  sed -i "s/username: .*#ali/username: ${DOCKER_REGISTRY_USER_infrastSubUser2} #ali/g" $authyml
  sed -i "s/password: .*#ali/password: ${DOCKER_REGISTRY_PW_infrastSubUser2} #ali/g" $authyml
  # LOCAL_DOMAIN # repo1.registry.local:$port
  sed -i "s/username: .*#local/username: ${DOCKER_REGISTRY_USER_dpinner} #local/g" $authyml
  sed -i "s/password: .*#local/password: ${DOCKER_REGISTRY_PW_dpinner} #local/g" $authyml
  sed -i "s/.*#LOCAL_DOMAIN/${LOCAL_URL}: #LOCAL_DOMAIN/g" $authyml
  cat $authyml |grep -v password

  # certs: ||insecure: true @auth.yml
   # ref1: syncer's Dockerfile
   # mkdir -p /etc/ssl/certs && update-ca-certificates --fresh

   # ref2: .psu/dpregistry.sh
   # headless @ armbian in /opt |14:11:18  
   # $ sudo bash set-certs.sh 
   # $ find /etc/docker/certs.d/
   #   /etc/docker/certs.d/deploy.xxx.com.ssl:$port/deploy.xxx.com.ssl.crt
}

function genImgList(){
  :> images.yml
  cat $1 |grep -Ev "^#|^$" |awk '{print $1}' |while read one; do
    # ghcr.io/octohelm/harbor/registry-photon:v2.6.2 ##ns多级目录
    local repo=$(echo $one |cut -d'/' -f1); 
    local img=${one##*/}; 
    local ns=$(echo $one |sed "s^$repo/^^g" |sed "s^/$img^^g"); 
    plain=$(echo $ns |sed "s^/^-^g")
    
    local src=$one
    local dst="$ALI_URL/infrasync/${plain}-$img"
    local dst2="$LOCAL_URL/infrasync/${plain}-$img"
    if [ "true" == "$SYNC_ALI" ]; then
      proc="--proc 1" #多了hub取不到
      echo "$src: $dst" >> images.yml
    else
      proc="--proc 5"
      echo "$dst: $dst2" >> images.yml
    fi
  done
  cat images.yml #view
}
# v2: 单个img:ns--img-tag
function genImgList_v2(){
  :> images.yml
  cat $1 |grep -Ev "^#|^$" |awk '{print $1}' |while read one; do
    # ghcr.io/octohelm/harbor/registry-photon:v2.6.2 ##ns多级目录
    local repo=$(echo $one |cut -d'/' -f1); 
    local imgtag=$(echo $one |sed "s^$repo/^^g"); 
    plain=$(echo $imgtag |sed "s^/^--^g") #/ >--
    plain=$(echo $plain |sed "s^:^---^g") #: >---
    
    local src=$one
    local dst="$ALI_URL/$ALI_IMG:${plain}"
    local dst2="$LOCAL_URL/$ALI_IMG:${plain}"
    if [ "true" == "$SYNC_ALI" ]; then
      proc="--proc 1" #多了hub取不到
      echo "$src: $dst" >> images.yml
    else
      proc="--proc 5"
      echo "$dst: $dst2" >> images.yml
    fi
  done
  cat images.yml #view
}

source /etc/profile #DOCKER_REGISTRY_USER/PW_dockerhub
authConf
genImgList_v2 $SYNC_LIST

# https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz
file=image-syncer-x64.tar.gz #oci support
test -s "$file" || curl -s -k -o /tmp/$file -fSL https://gitee.com/infrastlabs/fk-image-syncer/releases/download/v23.4.25/$file
tar -zxf /tmp/$file -C /tmp #解压后README.md会替换(更新README2.md)
# gitac: cp: cannot create regular file '/bin/syncer': Permission denied
\cp -a /tmp/image-syncer-x64 ./syncer; #chmod +x /bin/syncer

# --proc 1 #多了hub取不到
# --arch $SYNC_ARCH ##16.04; 14.04, mismatch of os or architecture ##view: 变成全arch, 该方式无效
#   TODO: --arch $SYNC_ARCH >> 转换为 --arch=amd64 --arch=arm64 --arch=arm
./syncer $proc --auth $authyml --images ./images.yml --arch=amd64 --arch=arm64 --arch=arm


exit 0
# usage
# export SYNC_ALI=true
# export SYNC_LIST="src.txt"
# export SYNC_ARCH="amd64,arm64"
# # 
# export ALI_URL="registry.cn-shenzhen.aliyuncs.com"
# export ALI_IMG="infrasync/v2025"
# export LOCAL_URL="server.k8s.local:18443"
# export LOCAL_IP="172.25.21.60"


export LOCAL_URL="harbor.xxx.com"
export LOCAL_IP="172.25.20.115"
bash syncer/run.sh