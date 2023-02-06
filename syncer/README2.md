
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