
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
case "$1" in
bins)
    # cd bins2
    img="edgecore:bins-v2.4"
    docker build -t $repo/$ns/$img -f bins2/Dockerfile .
    docker push $repo/$ns/$img
    ;;
alma)
    img="env-centos:alma8.7-v1"
    docker build -t $repo/$ns/$img -f imgs/Dockerfile.alma .
    docker push $repo/$ns/$img
    ;;
alma-sdk) #--build-arg TARGETPLATFORM="linux/amd64" 
    img="env-centos:alma8.7-sdk-v1"
    docker build --build-arg TARGETPLATFORM="linux/amd64" -t $repo/$ns/$img -f imgs/Dockerfile.alma-sdk .
    docker push $repo/$ns/$img
    ;;
alma-sdk-data) #x64下本地制作，(本地x64/arm64的包，存于img内)
    img="env-centos:alma8.7-sdk-data"
    docker build -t $repo/$ns/$img -f imgs/Dockerfile.alma-sdk-data .
    docker push $repo/$ns/$img
    ;;
*)
    docker build --build-arg TARGETPLATFORM="linux/amd64" -t $repo/$ns/$img .
    docker push $repo/$ns/$img
    ;;
esac
