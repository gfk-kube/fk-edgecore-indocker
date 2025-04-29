## Usage

### 1）imgList

```bash
# v1
ghcr.io/octohelm/harbor/harbor-exporter:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-harbor-exporter:v2.6.2
ghcr.io/octohelm/harbor/redis-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/octohelm-harbor-redis-photon:v2.6.2

# v2025
ghcr.io/octohelm/harbor/redis-photon:v2.6.2: registry.cn-shenzhen.aliyuncs.com/infrasync/v2015:octohelm--harbor--redis-photon---v2.6.2
```

### 2）转国内<ALI仓>

- wget https://ghproxy.com/https://github.com/AliyunContainerService/image-syncer/releases/download/v1.3.1/image-syncer-v1.3.1-linux-amd64.tar.gz

```bash
# v2025
export SYNC_ALI=true #default:false
export SYNC_LIST="src.txt"
export SYNC_ARCH="amd64,arm64"
# 
export ALI_URL="registry.cn-shenzhen.aliyuncs.com"
export ALI_IMG="infrasync/v2025"
bash syncer/run.sh

# FF
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

### 3）转私仓

```bash
# v2025.转私仓01 #botom@syncer/run.sh
export DOCKER_REGISTRY_USER_dpinner=admin
export DOCKER_REGISTRY_PW_dpinner=stk..
# 
# export LOCAL_URL="harbor.xxx.com"
# export LOCAL_IP="172.25.20.115"
export LOCAL_URL="172.25.21.60:8000" #http.8000 https.8143; domain:registry01.k8s.local
export LOCAL_IP="172.25.21.60"
export LOCAL_FORMAT='$nslast/$img:$tag' #nsfull/nslast; use '', not ""
bash syncer/run.sh #view: cat /tmp/auth.yml

# v2025.转私仓02: https


# FF
## test推私服(tls)
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


## 附

### 0）IP.Registry//domain.CA

```bash
host-21-60:~ # ss -ntlp |grep 8143
  LISTEN  0   128    *:8143    *:*  users:(("docker-registry",pid=2477,fd=3))
  host-21-60:~ # ss -ntlp |grep docker-registry
  LISTEN  0   128    *:8143    *:*  users:(("docker-registry",pid=2477,fd=3))
  LISTEN  0   128    *:8000    *:*  users:(("docker-registry",pid=2477,fd=7))

# IP.Registry
# 21.60 未设置
  host-21-60:/opt/apps/fk-edgecore-indocker # docker login 172.25.21.60:8000
  Username: admin
  Password: 
  Error response from daemon: Get https://172.25.21.60:8000/v2/: http: server gave HTTP response to HTTPS client
  host-21-60:/opt/apps/fk-edgecore-indocker # cat /etc/docker/daemon.conf |grep secu
    "insecure-registries": ["127.0.0.1/8", "http://harbor.xx.com", "http://deploy.xx.com"],
# 11.53: "0.0.0.0/0"让所有IP都走insecure
  [root@pci-master-01 ~]# vi /etc/docker/daemon.json 
  [root@pci-master-01 ~]# cat /etc/docker/daemon.json |grep secu
    "insecure-registries": ["0.0.0.0/0"],
  [root@pci-master-01 ~]# systemctl restart docker
  [root@pci-master-01 ~]# docker login 172.25.21.60:8000
  Username: admin
  Password: 
  Login Succeeded

# domain.CA
# TODO


# 同步本地仓LOG:
  172.25.20.115 harbor.xxx.com
  registry.hub.docker.com:
    username:  #hub
  registry.cn-shenzhen.aliyuncs.com:
    username:  #ali
  harbor.xxx.com: #LOCAL_DOMAIN
    username: admin #local
    insecure: true
  # quay.io:
  #   username: xxx
  #   insecure: true
  # quay.io/coreos:
  #   username: abc
  #   insecure: true
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--ks-apiserver---v4.1.3: harbor.xxx.com/kubesphere/ks-apiserver:v4.1.3
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--ks-console---v4.1.3: harbor.xxx.com/kubesphere/ks-console:v4.1.3
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--ks-controller-manager---v4.1.3: harbor.xxx.com/kubesphere/ks-controller-manager:v4.1.3
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--kubectl---v1.27.16: harbor.xxx.com/kubesphere/kubectl:v1.27.16
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--redis---7.2.4-alpine: harbor.xxx.com/kubesphere/redis:7.2.4-alpine
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--haproxy---2.9.6-alpine: harbor.xxx.com/kubesphere/haproxy:2.9.6-alpine
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--ks-extensions-museum---v1.1.6: harbor.xxx.com/kubesphere/ks-extensions-museum:v1.1.6
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubeedge--iptables-manager---v1.13.1: harbor.xxx.com/kubeedge/iptables-manager:v1.13.1
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubeedge--cloudcore---v1.13.1: harbor.xxx.com/kubeedge/cloudcore:v1.13.1
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubeedge--controller-manager---v1.13.1: harbor.xxx.com/kubeedge/controller-manager:v1.13.1
  registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--kubeedge-proxy---v0.4.1: harbor.xxx.com/kubesphere/kubeedge-proxy:v0.4.1
....
INFO[2025-04-29 17:25:08] Put manifestList to harbor.xxx.com/kubesphere/ks-console:v4.1.3 
INFO[2025-04-29 17:25:08] Synchronization successfully from registry.cn-shenzhen.aliyuncs.com/infrasync/v2025:kubesphere--ks-console---v4.1.3 to harbor.xxx.com/kubesphere/ks-console:v4.1.3 
Finished, 0 sync tasks failed, 0 tasks generate failed
INFO[2025-04-29 17:25:08] Finished, 0 sync tasks failed, 0 tasks generate failed 

# host-21-60:/opt/apps/fk-edgecore-indocker # cat /tmp/auth.yml 
registry.hub.docker.com:
  username:  #hub
  password:  #hub
registry.cn-shenzhen.aliyuncs.com:
  username:  #ali
  password:  #ali
harbor.xxx.com: #LOCAL_DOMAIN
  username: admin #local
  password: xx #local
  insecure: true
# quay.io:
#   username: xxx
#   password: xxxxxxxxx
#   insecure: true
# quay.io/coreos:
#   username: abc
#   password: xxxxxxxxx
#   insecure: true
```

### 1）Undock (oci,从img中取出文件)

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
