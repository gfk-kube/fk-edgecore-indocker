
source /etc/profile
sed -i "s/username: .*#ali/username: ${DOCKER_REGISTRY_USER_infrastSubUser2} #ali/g" auth.yml
sed -i "s/password: .*#ali/password: ${DOCKER_REGISTRY_PW_infrastSubUser2} #ali/g" auth.yml
cat auth.yml

./image-syncer --auth ./auth.yml --images ./images.yml --arch=amd64 --arch=arm64 #--arch amd64,arm64
