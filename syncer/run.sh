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
test -z "$LOCAL_FORMAT"  && LOCAL_FORMAT="" #keep infrasync/v2025:ns--img---tag
# test -z "$SYNC_LIST" && errExit "please with src.txt"

function errExit(){
  echo "ERR: $1"
  exit 1
}

# auth: hub仓,ali仓,本地仓
function authConf(){
  # hosts
  LOCAL_URL2=${LOCAL_URL%:*}
  cat /etc/hosts |egrep -v " $LOCAL_URL2$" > /tmp/hosts;  test "$LOCAL_IP" == "$LOCAL_URL2" || echo "$LOCAL_IP $LOCAL_URL2" >> /tmp/hosts #URL为IP模式时不写入
  cat /tmp/hosts |sudo tee /etc/hosts; #cat /etc/hosts |grep "$LOCAL_URL2" #view

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

# v1: infrasync/ns-img:tag
function genImgList(){
  :> images.yml
  cat $1 |grep -Ev "^#|^$" |awk '{print $1}' |while read one; do
    # ghcr.io/octohelm/harbor/registry-photon:v2.6.2 ##ns多级目录
    local repo=$(echo $one |cut -d'/' -f1); 
    local imgtag=${one##*/}; 
    local ns=$(echo $one |sed "s^$repo/^^g" |sed "s^/$imgtag^^g"); 
    nsplain=$(echo $ns |sed "s^/^-^g")
    
    local src=$one
    local dst="$ALI_URL/infrasync/${nsplain}-$imgtag"
    local dst2="$LOCAL_URL/infrasync/${nsplain}-$imgtag"
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
    local repo=$(echo $one |cut -d'/' -f1) 
    local nsimgtag=$(echo $one |sed "s^$repo/^^g")
    local plain=$(echo $nsimgtag |sed "s^/^--^g") #/ >--
    plain=$(echo $plain |sed "s^:^---^g") #: >---

    # 25.4.19: +ns, imgtag
    local imgtag=${nsimgtag##*/}; tag=${imgtag##*:}; img=${imgtag%%:*}
    local ns=$(echo $nsimgtag |sed "s^/$imgtag^^g")
    #ns.plain 如ns多级目录,  {harbor不支持; registry:可?}
    #  1.nsfull: 暂转--
    #  2.nslast: 只取最后一个:相对符合实用
    nsfull=$(echo $ns |sed "s^/^--^g")
    nslast=${ns##*/}
    
    local src=$one
    local dst="$ALI_URL/$ALI_IMG:${plain}"
    local dst2="$LOCAL_URL/$ALI_IMG:${plain}"
    if [ "true" == "$SYNC_ALI" ]; then
      proc="--proc 1" #多了hub取不到
      echo "$src: $dst" >> images.yml
    else
      # 转私仓时允许自定格式;
      local nsimgtag2=$(eval echo $LOCAL_FORMAT)
      test -z "$nsimgtag2" || dst2="$LOCAL_URL/${nsimgtag2}" #非空时设定,如空则还是前面格式:infrasync/v2025:ns--img---tag

      proc="--proc 5"
      echo "$dst: $dst2" >> images.yml
    fi
  done
  cat images.yml #view
}

source /etc/profile #DOCKER_REGISTRY_USER/PW_dockerhub
authConf
genImgList_v2 $SYNC_LIST

function getSyncer(){
  file=image-syncer-x64.tar.gz #oci support
  # gitee: self's multi-manifests sync
  # curl: (22) The requested URL returned error: 403
  test -s "$file" || curl -s -k -o /tmp/$file -fSL https://gitee.com/infrastlabs/fk-image-syncer/releases/download/v23.4.25/$file
  local errCode=$?
  # org's-hub
  #  https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz
  #  https://github.com/AliyunContainerService/image-syncer/releases/download/v1.5.5/image-syncer-v1.5.5-linux-amd64.tar.gz #v155@Jul 22, 2024
  test "0" == "$errCode" || curl -s -k -o /tmp/$file -fSL https://github.com/AliyunContainerService/image-syncer/releases/download/v1.5.5/image-syncer-v1.5.5-linux-amd64.tar.gz
  
  tar -zxf /tmp/$file -C /tmp #解压后README.md会替换(更新README2.md)
  # gitac: cp: cannot create regular file '/bin/syncer': Permission denied
  \cp -a /tmp/image-syncer-x64 ./syncer; #chmod +x /bin/syncer
}
getSyncer

# --proc 1 #多了hub取不到
# --arch $SYNC_ARCH ##16.04; 14.04, mismatch of os or architecture ##view: 变成全arch, 该方式无效
#   TODO: --arch $SYNC_ARCH >> 转换为 --arch=amd64 --arch=arm64 --arch=arm
./syncer $proc --auth $authyml --images ./images.yml --arch=amd64 --arch=arm64 --arch=arm


exit 0
# usage
# export SYNC_ALI=true #default:false
# export SYNC_LIST="src.txt"
# export SYNC_ARCH="amd64,arm64"
# # 
# export ALI_URL="registry.cn-shenzhen.aliyuncs.com"
# export ALI_IMG="infrasync/v2025"
# export LOCAL_URL="server.k8s.local:18443"
# export LOCAL_IP="172.25.21.60"


export LOCAL_URL="harbor.xxx.com"
export LOCAL_IP="172.25.20.115"
export LOCAL_FORMAT='$nslast/$img:$tag' #nsfull/nslast; use '', not ""
export LOCAL_FORMAT='infrasync/v2025:$nsfull--$img---$tag' #unset为空时,即该模式
bash syncer/run.sh

# toAli:
  # quay.io/kubevirt/virt-operator:v1.5.1: registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubevirt--virt-operator---v1.5.1
# eval https://blog.csdn.net/qq_35902025/article/details/140180780
  # [root@(⎈|default:kubeedge) ~]$ ns=infrasync
  # [root@(⎈|default:kubeedge) ~]$ img=alpine
  # [root@(⎈|default:kubeedge) ~]$ tag=3.13.15
  # [root@(⎈|default:kubeedge) ~]$ export LOCAL_FORMAT='$ns/$img:$tag'
  # [root@(⎈|default:kubeedge) ~]$ eval $LOCAL_FORMAT
  # bash: infrasync/alpine:3.13.15: No such file or directory
  # 
  # [root@(⎈|default:kubeedge) ~]$ val=$(eval echo $LOCAL_FORMAT)
  # [root@(⎈|default:kubeedge) ~]$ echo $val
  # infrasync/alpine:3.13.15