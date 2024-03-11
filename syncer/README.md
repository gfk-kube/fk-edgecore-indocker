
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

# 24.7.5 update:
# v040@Feb 14, 2023> v070@Dec 22, 2023> v080@Jun 28, 2024
# v070
  #Docker auth config support (#186)
# v050
  #Support image:tag@digest format (#131)
  #Go 1.20 (#114 #133)
# v040
  #Go 1.19 (#65 #25)

headless @ barge in ~ |18:07:22  
$ cat .docker/config.json 
{
	"auths": {
		"test.registry.ssl:8143": {
			"auth": "YWRtaW46YWRtaW4xMjM="
		},
        "172.25.20.161:18443": {
			"auth": "YWRtaW46YWRtaW4xMjM="
		}
	},
	"HttpHeaders": {
		"User-Agent": "Docker-Client/18.09.8 (linux)"
	}
}
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

## imgList

```bash
ghcr.io/octohelm/harbor/harbor-exporter:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-exporter:v2.6.2
ghcr.io/octohelm/harbor/redis-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-redis-photon:v2.6.2
ghcr.io/octohelm/harbor/trivy-adapter-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-trivy-adapter-photon:v2.6.2
ghcr.io/octohelm/harbor/harbor-registryctl:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-registryctl:v2.6.2
ghcr.io/octohelm/harbor/registry-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-registry-photon:v2.6.2
ghcr.io/octohelm/harbor/nginx-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-nginx-photon:v2.6.2
ghcr.io/octohelm/harbor/harbor-log:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-log:v2.6.2
ghcr.io/octohelm/harbor/harbor-jobservice:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-jobservice:v2.6.2
ghcr.io/octohelm/harbor/harbor-core:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-core:v2.6.2
ghcr.io/octohelm/harbor/harbor-portal:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-portal:v2.6.2
ghcr.io/octohelm/harbor/harbor-db:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-db:v2.6.2
ghcr.io/octohelm/harbor/prepare:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-prepare:v2.6.2
registry-1.docker.io/library/redis:7.0.0: registry.cn-shenzhen.aliyuncs.com/infrasync/library-redis:7.0.0
docker.io/kubeedge/cloudcore:v1.13.5: registry.cn-shenzhen.aliyuncs.com/infrasync/kubeedge-cloudcore:v1.13.5
docker.io/kubeedge/installation-package:v1.13.5: registry.cn-shenzhen.aliyuncs.com/infrasync/kubeedge-installation-package:v1.13.5
docker.io/library/eclipse-mosquitto:1.6.15: registry.cn-shenzhen.aliyuncs.com/infrasync/library-eclipse-mosquitto:1.6.15
docker.io/kubeedge/installation-package:v1.15.2: registry.cn-shenzhen.aliyuncs.com/infrasync/kubeedge-installation-package:v1.15.2
# 
#  time="2024-03-11 09:36:15" level=info msg="Finished, 0 sync tasks failed, 0 tasks generate failed"

```