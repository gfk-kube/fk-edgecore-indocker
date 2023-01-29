#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)
cd $cur
AUTH="root:root"


# node
# 21.2M
curl -O -fSL https://npm.taobao.org/mirrors/node/v14.20.0/node-v14.20.0-linux-x64.tar.xz
# 20.5M
curl -O -fSL https://npm.taobao.org/mirrors/node/v14.20.0/node-v14.20.0-linux-arm64.tar.xz

# oracle_java8u202
# 185M
curl -O -fSL -u $AUTH http://172.25.23.203/repository1/v3_base_data/v2/packages/3rdparty/jdk/jdk-8u202-linux-x64.tar.gz
# 69.7M
curl -O -fSL -u $AUTH http://172.25.23.203/repository1/v3_base_data/v2/packages/3rdparty/jdk/jdk-8u202-linux-arm64-vfp-hflt.tar.gz
