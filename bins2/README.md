
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