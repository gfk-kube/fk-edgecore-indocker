#!/bin/bash

source /etc/profile
export |grep DOCKER_REG
repo=registry.cn-shenzhen.aliyuncs.com
echo "${DOCKER_REGISTRY_PW_infrastSubUser2}" |docker login --username=${DOCKER_REGISTRY_USER_infrastSubUser2} --password-stdin $repo

repoHub=docker.io
echo "${DOCKER_REGISTRY_PW_dockerhub}" |docker login --username=${DOCKER_REGISTRY_USER_dockerhub} --password-stdin $repoHub
        
ns=infrastlabs
# ver=v1.13.0-k2317-v2.4 #v2
ver=lite2.5
case "$1" in
alma)
    echo "baseImgs>> alma"
    ver=v2.1
    repo="registry.cn-shenzhen.aliyuncs.com"
    img="env-centos:alma8.7-$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-centos-cache:alma8.7-$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.alma . 
    ;;
alma-sdk)
    echo "baseImgs>> alma-sdk"
    ver=v2.1
    
    #推hub: github ac:推不上去, 6h-timeout fail
    #ali仓：可推multi,但之后syncer取不了(OCI.image)>> (2.16号晚)自改syncer已支持
    repo="registry.cn-shenzhen.aliyuncs.com"
    # repo=registry-1.docker.io 
    img="env-centos:alma8.7-sdk-$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-centos-cache:alma8.7-sdk-$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.alma-sdk . 
    ;;
ansible)
    echo "baseImgs>> ansible"
    # ver=alpine3.7-v2.4.6
    ver=alpine3.8-v2.6.20
    repo="registry.cn-shenzhen.aliyuncs.com"
    img="env-ansible:$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-ansible-cache:$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible . 
    ;;
ansible-mitogen)
    echo "baseImgs>> ansible-mitogen"
    # ver=alpine3.7-v2.4.6
    # ver=alpine3.8-v2.6.20
    # ver=alpine3.14-v2.9.27-mitogen
    # ver=alpine3.10-ansi2.8.8py3710-mitogen
    # ver=alpine3.14-v2.10.17py3917-mitogen
    ver=alpine3.14-v2.10.17py3917-mitogen-v210corebase #notes: pip3 ins ansible==v2.10.7; >> auto-dp-lite在用;
    repo="registry.cn-shenzhen.aliyuncs.com"
    img="env-ansible:$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-ansible-cache:$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64 --provenance=false" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mitogen . 
    ;;
ansible-mitogen-alpine38) ##base
    echo "baseImgs>> ansible-mitogen-alpine38"
    # ver=alpine3.7-v2.4.6
    # ver=alpine3.8-v2.6.20
    # 
    # ver=alpine3.8-v2.5.15-mitogen-base #ERR
    # ver=alpine3.8-v2.7.11-mitogen-base #ERR
    # ver=alpine3.9-v2.8.7py2-mitogen-base #ERR
    # ver=alpine3.10-v2.8py3-mitogen-base #OK1
    # ver=alpine3.10-v2.9.13py3-mitogen-base
    # ver=alpine3.10-v2.10.16py3-mitogen-base
    # ver=alpine3.12-v2.9.27py3-mitogen-base #ERR2
    # ver=alpine3.14-v2.10.17py3-mitogen-base
    ver=alpine3.14-v2.13.7py3-mitogen-base

    repo="registry.cn-shenzhen.aliyuncs.com"
    img="env-ansible:$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-ansible-cache:$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64 --provenance=false" ##,linux/arm
    args="--build-arg FULL=/.."
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine39-ansi28py2 .
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine310-ansi28py3 . 
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine310-ansi29py3 .
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine310-ansi210py3 . ##438M? too big;
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine312-ansi29py3 .
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine314-ansi210py3 . #org's 143M? (ansi> ansi-base)
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-alpine314-ansi213py3 . #(ansi> ansi-base> ansi-core)
    ;;
ansible-ubt2004)
    echo "baseImgs>> ansible-mitogen-ubt2004"
    # ver=alpine3.7-v2.4.6
    # ver=alpine3.8-v2.6.20
    ver=ubt2004-v2.9.27-mitogen
    repo="registry.cn-shenzhen.aliyuncs.com"
    img="env-ansible:$ver"
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="env-ansible-cache:$ver"
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f imgs/Dockerfile.ansible-mtg-ubt2004 . 
    ;;
syncer)
    echo "syncer: imgSync"
    bash syncer/run.sh
    ;;
*)
    # repo=registry-1.docker.io
    repo="registry.cn-shenzhen.aliyuncs.com" #image-sync推docker:20.10.18,ali仓是支持multiArch的
    img="edgecore:$ver" #multi- (barge_docker v1.10.3 not support '-')
    # cache
    ali="registry.cn-shenzhen.aliyuncs.com"
    cimg="edgecore-cache:$ver" #multi- 
    cache="--cache-from type=registry,ref=$ali/$ns/$cimg --cache-to type=registry,ref=$ali/$ns/$cimg"

    plat="--platform linux/amd64,linux/arm64" ##,linux/arm
    args="--build-arg FULL=/.."
    # docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f Dockerfile . 
    docker buildx build $cache $plat $args --push -t $repo/$ns/$img -f Dockerfile.lite . 

    ;;
esac

# up build