# 

从../../fat-container/fat-centos拷贝

## 条目类

**systemImg**

- centos7/ubuntu1804 + systemd
- yum/apt源
- openssh-server/openssh-clients
- 
- ctoper/jumpadmin/root
- dp-centos-init: libselinux-python selinux-policy rsyslog 
- mysql: numactl.x86_64
- 

**recs**

- mem/cpu update
  - docker update -m 4096m 60cd056c07b1

**limit**

- cpu/mem: lxcfs
- disk: overlay2 + xfs #按vm/bare做规格; 外挂盘;
- io: 原生 (disk / net?)

## 使用

**cmd**

```bash
# x2 4G 50G: ff_fat
img=registry.cn-shenzhen.aliyuncs.com/infrastlabs/fat-centos
docker run -it --rm --privileged \
  --device-write-bps /dev/sda:10MB \
  -c 1024 --cpuset-cpus=0,1 \
  -m 4096m $vols\
$img
# 
echo root:132 |chpasswd 
```

## Env-centos7

```bash
wget https://hub.fastgit.org/krallin/tini/releases/download/v0.19.0/tini-amd64 
```

- user

```bash
# deploy
useradd -m -s /bin/bash deploy
echo "deploy:Deploy123" |chpasswd 
echo "deploy ALL=(root) NOPASSWD: ALL" >> /etc/sudoers


#容器内可直接这么建立
user=pciapp; uid=9021
group=pciapp; gid=9021

groupadd -g $gid $group
useradd -u $uid -g $gid -m -s /bin/bash $user
```