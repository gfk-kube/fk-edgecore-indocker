
source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

# repoHub=docker.io
# echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
# repo=registry-1.docker.io
ns=infrastlabs
ver=v5

# img="edgecore:v1.10.3"
img="edgecore:latest"

#buildx
# plat="--platform linux/amd64,linux/arm64" #,linux/arm
# --network=host: docker buildx create --use --name mybuilder2 --buildkitd-flags '--allow-insecure-entitlement network.host'
# docker buildx build $plat --push -t $ns/$img -f src/Dockerfile.compile . 

#dockerBuild
docker build -t $repo/$ns/$img .
docker push $repo/$ns/$img
