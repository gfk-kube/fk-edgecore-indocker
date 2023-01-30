#!/bin/bash

source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
ns=infrastlabs
ver=v1.13.0-k2315 #v2
case "$1" in
base)
    echo "base"
    ;;
*)
    # repo=registry-1.docker.io
    repo="registry.cn-shenzhen.aliyuncs.com" #image-sync推docker:20.10.18,ali仓是支持multiArch的
    img="edgecore:multi-$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="edgecore-cache:multi-$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f Dockerfile . 

    ;;
esac