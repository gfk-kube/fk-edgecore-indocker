
## imgVers

- loadBins_old.sh 弃用
- imgbuild.sh 本地构建
  - step1 `bash tplat.v2505.sh`
  - step2 `bash imgbuild.sh bins`
- Dockerfile.v2301-bin25 + plat.sh
  - `ADD ./bins2/tplat.sh /bin/tplat` (已弃,参考`tplat.v2405.sh> function tplat(){`)
  - `tplat $arch https://ghproxy.com/https://github.com  @Dockerfile.v2301-bin25` 在dockerfile内下载
- Dockerfile.v2405 + tplat.v2405.sh
  - 下载列表改到plat.v2405.sh内:先执行脚本再本地ADD构建img
  - `GITHUB=https://hub.yzuu.cf; tplat $arch $GITHUB`
- Dockerfile.v2405 + tplat.v2505.sh
  - 2505:全量更新相关组件版本
  - 2509:更新nerdctl-v214

```bash
# headless @ mac23-199 in .../fk-edgecore-indocker/bins2 |00:15:26  |sam-custom2 U:1 ✗| 
$ curl -O -fSL https://ghproxy.com/https://github.com/containerd/containerd/releases/download/v1.6.15/containerd-1.6.15-linux-amd64.tar.gz
$ curl -O -fSL https://ghproxy.com/https://github.com/opencontainers/runc/releases/download/v1.1.4/runc.amd64
# curl -O -fSL https://ghproxy.com/https://github.com/containerd/fuse-overlayfs-snapshotter/releases/download/v1.0.5/containerd-fuse-overlayfs-1.0.5-linux-amd64.tar.gz
# https://ghproxy.com/https://github.com/containerd/nerdctl/releases/download/v1.1.0/nerdctl-1.1.0-linux-amd64.tar.gz

$ tree -h |grep -E ".tar.gz|.tgz" |sort > tree.txt
```

## vers

```bash
# headless @ mac23-199 in .../fk-edgecore-indocker/bins2 |00:20:27  |sam-custom2 ✓| 
$ chmod +x runc.amd64
$ ./runc.amd64 --version
runc version 1.1.4
commit: v1.1.4-0-g5fd4c4d1
spec: 1.0.2-dev
go: go1.17.10
libseccomp: 2.5.4

# headless @ mac23-199 in .../bins2/containerd-fuse-overlayfs-1.0.5-linux-amd64 |00:56:56  |sam-custom2 ✓| 
$ ./containerd-fuse-overlayfs-grpc --version
INFO[0000] containerd-fuse-overlayfs-grpc Version="v1.0.5" Revision="11c45f4d24689d8cb279813fbcb9bbd01773e0e8" 
invalid args: usage: ./containerd-fuse-overlayfs-grpc <unix addr> <root>

# 250905
Administrator@sam-pincun MINGW64 /d/UserData/Desktop/=repos/_ct/fk-edgecore-indocker/bins (dev)
$ cat tplat.v2405.sh |grep VER= -B 2 |egrep -v "^--|RUN"
  # containerd 1.6.15 41.4M; >> 1.6.32
    export VER=1.6.32; \
  # snapshotter 1.0.5 3820k >> 1.0.8
    export VER=1.0.8; \
  # cni 1.2.0 38.6M >> 1.5.0
    export VER=1.5.0; \
  # runc 1.1.4 9210k>> 1.1.12
    export VER=1.1.12; \
  # 23.10 +buildkit 0.12.2 >> 0.13.2
    export VER=0.13.2; \
  #   24.7.23: v176> nerdctl-2.0.0-rc.0-linux-arm64.tar.gz ##--provenance=false
    export VER=2.0.0-rc.0; \
  # crictl 1.26.0 21.8M >> 1.30.0
    export VER=1.30.0; \
  # k3s 1.22.17 48.9M
    export VER=1.22.17; \
  # k3s v1.23.17 62M
    export VER=1.23.17; \

Administrator@sam-pincun MINGW64 /d/UserData/Desktop/=repos/_ct/fk-edgecore-indocker/bins (dev)
$ cat tplat.v2505.sh |sed 's/^[[:blank:]]*//' |egrep -v "^#|^$" |grep VER= -A 1 |egrep -v "^--|RUN22"
  export VER=1.6.5; \
  $RUN tplat amd64 $GITHUB/cloudflare/cfssl/releases/download/v${VER}/cfssl_${VER}_linux_amd64; \
  export VER=1.5.5; \
  $RUN tplat amd64 $GITHUB/AliyunContainerService/image-syncer/releases/download/v${VER}/image-syncer-v${VER}-linux-amd64.tar.gz; \
  export VER=2.8.3; \
  $RUN tplat amd64 $GITHUB/distribution/distribution/releases/download/v${VER}/registry_${VER}_linux_amd64.tar.gz; \
  export VER=2.35.1; \
  $RUN tplat amd64 $GITHUB/docker/compose/releases/download/v${VER}/docker-compose-linux-x86_64; \
  export VER=1.7.27; \
  tplat amd64 $GITHUB/containerd/containerd/releases/download/v${VER}/containerd-${VER}-linux-amd64.tar.gz; \
  export VER=1.0.8; \
  tplat amd64 $GITHUB/containerd/fuse-overlayfs-snapshotter/releases/download/v${VER}/containerd-fuse-overlayfs-${VER}-linux-amd64.tar.gz; \
  export VER=1.7.1; \
  tplat amd64 $GITHUB/containernetworking/plugins/releases/download/v${VER}/cni-plugins-linux-amd64-v${VER}.tgz; \
  export VER=1.2.6; \
  tplat amd64 $GITHUB/opencontainers/runc/releases/download/v${VER}/runc.amd64; \
  export VER=0.21.1; \
  tplat amd64 $GITHUB/moby/buildkit/releases/download/v${VER}/buildkit-v${VER}.linux-amd64.tar.gz; \
  export VER=2.1.4; \
  tplat amd64 $GITHUB/containerd/nerdctl/releases/download/v${VER}/nerdctl-${VER}-linux-amd64.tar.gz; \
  export VER=1.33.0; \
  tplat amd64 $GITHUB/kubernetes-sigs/cri-tools/releases/download/v${VER}/crictl-v${VER}-linux-amd64.tar.gz; \
  export VER=1.26.15; \
  tplat amd64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s; \
  export VER=1.32.4; \
  tplat amd64 $GITHUB/k3s-io/k3s/releases/download/v${VER}%2Bk3s1/k3s; \

```

- **nerdctl-full-1.1.0-linux-amd64**

```bash
# headless @ mac23-199 in .../nerdctl-full-1.1.0-linux-amd64/bin |23:48:11  |sam-custom2 ✓| 
$ ./containerd --version
containerd github.com/containerd/containerd v1.6.12 a05d175400b1145e5e6a735a6710579d181e7fb0

$ ./runc --version
runc version 1.1.4
commit: v1.1.4-0-g5fd4c4d1
spec: 1.0.2-dev
go: go1.19.4
libseccomp: 2.5.1

$ ./buildkitd --version
buildkitd github.com/moby/buildkit v0.10.6 0c9b5aeb269c740650786ba77d882b0259415ec7

# 
headless @ mac23-199 in .../libexec/cni |23:52:01  |sam-custom2 ✓| 
$ ./ptp  --version
CNI ptp plugin v1.1.1
$ ./host-local --version
CNI host-local plugin v1.1.1
```

- **cri-containerd-cni-1.6.15-linux-amd64**

```bash
# headless @ mac23-199 in .../local/bin |00:00:04  |sam-custom2 ?:2 ✗| 
$ ./containerd --version
containerd github.com/containerd/containerd v1.6.15 5b842e528e99d4d4c1686467debf2bd4b88ecd86
$ ./crictl --version
crictl version 1.24.1

# headless @ mac23-199 in .../local/sbin |00:01:27  |sam-custom2 ?:2 ✗| 
$ ./runc --version
./runc: symbol lookup error: ./runc: undefined symbol: seccomp_notify_respond

# headless @ mac23-199 in .../cni/bin |00:03:17  |sam-custom2 ?:2 ✗| 
$ ./ptp  --version
CNI ptp plugin version unknown
$ ./host-local --version
CNI host-local plugin version unknown
```