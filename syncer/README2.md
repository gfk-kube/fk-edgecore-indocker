
- wget https://ghproxy.com/https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz

```bash
# headless @ mac23-199 in .../fk-edgecore-indocker/syncer |15:23:47  |dev U:1 ?:4 ✗| 
$ cat <<EOF |sudo tee -a /etc/profile
export DOCKER_REGISTRY_USER_infrastSubUser2=user-xx
export DOCKER_REGISTRY_PW_infrastSubUser2=xxxx
export DOCKER_REGISTRY_USER_dockerhub=xxx
export DOCKER_REGISTRY_PW_dockerhub=xxxxx

export DOCKER_REGISTRY_DST2_DOMAIN=deploy.xxx.com.ssl
export DOCKER_REGISTRY_USER_dpinner=xxx
export DOCKER_REGISTRY_PW_dpinner=xxxx
EOF
```

## undock (oci,从img中取出文件)

- https://github.com/crazy-max/undock/releases/download/v0.4.0/undock_0.4.0_windows_amd64.zip
- https://github.com/crazy-max/undock/releases/download/v0.4.0/undock_0.4.0_linux_amd64.tar.gz

```bash
# https://crazymax.dev/undock/usage/examples/
undock.exe --rm-dist --all registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.14.8 ./dist3

# --include /bin/busybox 取不到@win
# bin 可以
# bin/busybox 也可以 (win下不能带/)
undock.exe --include bin/busybox --rm-dist --all registry.cn-shenzhen.aliyuncs.com/infrasync/alpine:3.14.8 ./dist4

# try ociImage: ubuntu:20.04
undock.exe --include bin --rm-dist --all ubuntu:20.04 ./ubt1
```

## test推私服(tls)

```bash
###01: 生成新push images.yml

###02: 证书错误>> 23.199内 生成etc/docker/certs.d

###03: auth认证错误（可复用~/.docker/config.json）
# 23.199> 23.22: 加host, etc/docker/certs.d;
# 23.199 login: /home/headless/.docker/config.json
# infrasync: 可推送
# infrasync222: part1可推送
# infrasync222: part2 移走~/.docker/config.json>> 不可推,authFail

###04: fixed>> auth.yml仓库标识，不用registry.前缀

```