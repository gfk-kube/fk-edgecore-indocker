
file=image-syncer-v1.3.1-linux-amd64.tar.gz
test -s "$file" || curl -O -fSL https://ghproxy.com/https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/$file
test -s ./image-syncer || tar -zxf $file #解压后README.md会替换(更新README2.md)

function errExit(){
   echo "ERR: $1"
   exit 1
}
function startSync(){
source /etc/profile
# DOCKER_REGISTRY_DST2_DOMAIN=deploy.xxx.com.ssl
match=$(cat /etc/hosts |grep $DOCKER_REGISTRY_DST2_DOMAIN)

# hosts
# test -z "$match" && echo "172.25.21.60 $DOCKER_REGISTRY_DST2_DOMAIN" >> /etc/hosts
if [ -z "$match" ]; then
   cat <<EOF |sudo tee -a /etc/hosts
172.25.21.60 $DOCKER_REGISTRY_DST2_DOMAIN
EOF
fi
cat /etc/hosts |grep "$DOCKER_REGISTRY_DST2_DOMAIN"

# $authyml
authyml=/tmp/auth.yml; cat auth.yml > $authyml
# +replaceAcc
sed -i "s/username: .*#ali/username: ${DOCKER_REGISTRY_USER_infrastSubUser2} #ali/g" $authyml
sed -i "s/password: .*#ali/password: ${DOCKER_REGISTRY_PW_infrastSubUser2} #ali/g" $authyml
sed -i "s/username: .*#hub/username: ${DOCKER_REGISTRY_USER_dockerhub} #hub/g" $authyml
sed -i "s/password: .*#hub/password: ${DOCKER_REGISTRY_PW_dockerhub} #hub/g" $authyml

# registry.deploy.xxx.com.ssl:18443: #DST2_DOMAIN
sed -i "s/.*#DST2_DOMAIN/${DOCKER_REGISTRY_DST2_DOMAIN}:18443: #DST2_DOMAIN/g" $authyml
sed -i "s/username: .*#dpRegistry/username: ${DOCKER_REGISTRY_USER_dpinner} #dpRegistry/g" $authyml
sed -i "s/password: .*#dpRegistry/password: ${DOCKER_REGISTRY_PW_dpinner} #dpRegistry/g" $authyml
# 
edgeRegistry_USER=admin; edgeRegistry_PW=admin123
sed -i "s/username: .*#edgeRegistry/username: ${edgeRegistry_USER} #edgeRegistry/g" $authyml
sed -i "s/password: .*#edgeRegistry/password: ${edgeRegistry_PW} #edgeRegistry/g" $authyml
cat $authyml |grep -v password

# certs: 
   # ref1: syncer's Dockerfile
   # mkdir -p /etc/ssl/certs && update-ca-certificates --fresh

   # ref2: .psu/dpregistry.sh
   # headless @ armbian in /opt |14:11:18  
   # $ sudo bash set-certs.sh 
   # $ find /etc/docker/certs.d/
   # /etc/docker/certs.d/deploy.xxx.com.ssl:18443/deploy.xxx.com.ssl.crt

# --proc 1 #多了hub取不到
./image-syncer $proc --auth $authyml --images ./images.yml --arch=amd64 --arch=arm64 #--arch amd64,arm64
}

function genImgList(){
:> images.yml
cat $1 |grep -Ev "^#|^$" |awk '{print $1}' |while read one; do

   src=$one
   plain=$(echo $one |sed "s^registry.cn-shenzhen.aliyuncs.com/^^g" |sed "s^/^-^g")
   dst="registry.cn-shenzhen.aliyuncs.com/infrasync/$plain"
   if [ "true" != "$tlsPrivate" ]; then
      proc="--proc 1" #多了hub取不到
      echo "$src: $dst" >> images.yml
   else
      proc="--proc 5"
      # dst2="172.25.21.60:18443/infrasync/$dst"
      dst2="$DOCKER_REGISTRY_DST2_DOMAIN:18443/infrasync/$plain"
      echo "$dst: $dst2" >> images.yml
   fi
done
cat images.yml
}

# test "" == "$1" && errExit "please with src.txt"
tlsPrivate=true2
test "true" == "" && src=src.txt || src=src0.txt
DOCKER_REGISTRY_DST2_DOMAIN="server.k8s.local"
genImgList $src #$1
startSync
