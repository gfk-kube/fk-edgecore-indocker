function startSync(){
source /etc/profile
sed -i "s/username: .*#ali/username: ${DOCKER_REGISTRY_USER_infrastSubUser2} #ali/g" auth.yml
sed -i "s/password: .*#ali/password: ${DOCKER_REGISTRY_PW_infrastSubUser2} #ali/g" auth.yml
sed -i "s/username: .*#hub/username: ${DOCKER_REGISTRY_USER_dockerhub} #hub/g" auth.yml
sed -i "s/password: .*#hub/password: ${DOCKER_REGISTRY_PW_dockerhub} #hub/g" auth.yml
cat auth.yml |grep -v password

# --proc 1 #多了hub取不到
./image-syncer --proc 1 --auth ./auth.yml --images ./images.yml --arch=amd64 --arch=arm64 #--arch amd64,arm64
}

:> images.yml
cat src.txt |grep -Ev "^#|^$" |awk '{print $1}' |while read one; do

   src=$one
   dst=$(echo $one |sed "s^/^-^g")
   dst="registry.cn-shenzhen.aliyuncs.com/infrasync/$dst"
   echo "$src: $dst" >> images.yml
done

cat images.yml
startSync
