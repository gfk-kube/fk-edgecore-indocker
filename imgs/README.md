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

## env-ansible

```bash
# ubt2004-v2.9.27-mitogen: 599MB> 683MB
# alpine3.14-v2.9.27-mitogen: 239MB> 333MB >> 340MB(glibc225)
# 
host-21-60:~ # docker images |grep ansi
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                    ubt2004-v2.9.27-mitogen                         766b12e136f7        54 seconds ago      683MB
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible   alpine3.14-v2.9.27-mitogen   3976919cab44        10 minutes ago      340MB ##23.195 pull
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                    alpine3.14-v2.9.27-mitogen                      a348e450b179        5 hours ago         333MB
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                    alpine3.8-v2.6.20                               5ed978dd5e53        6 hours ago         264MB
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                    alpine3.7-v2.4.6                                cafcd07b252d        7 hours ago         153MB
# 
cytopia/ansible                                                              2.8                                             9c594d45530d        12 hours ago        187MB
willhallonline/ansible                                                       2.9-alpine-3.14                                 782a333a02e9        3 months ago        239MB
willhallonline/ansible                                                       2.9-ubuntu-20.04                                8720119d6c50        5 months ago        599MB



[root@arm-ky10-23-2 opsdeploy]# docker run -it --rm willhallonline/ansible:2.9-alpine-3.14 sh
Unable to find image 'willhallonline/ansible:2.9-alpine-3.14' locally
2.9-alpine-3.14: Pulling from willhallonline/ansible
f7dab3ab2d6e: Already exists 
8dfb707f6b67: Already exists 
d922a4985b01: Already exists 
4f4fb700ef54: Already exists 
Digest: sha256:242c172c45e796c1ad1e76983b7b4af10a5c037849e9cceecb6fcf5234a7cdf6
Status: Downloaded newer image for willhallonline/ansible:2.9-alpine-3.14
standard_init_linux.go:207: exec user process caused "exec format error"


# ARM Releases
# https://github.com/willhallonline/docker-ansible
There is some support for Arm architecture.
    linux/arm64 (Macbook and AWS Graviton) to latest and alpine image tags.
    linux/arm/v7 and linux/arm/v6 to arm image tag (Raspberry Pi).

[root@arm-ky10-23-2 opsdeploy]# docker run -it --rm willhallonline/ansible:alpine sh
/ansible # ansible --version
ansible [core 2.15.4]
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.10/site-packages/ansible
  ansible collection location = /root/.ansible/collections:/usr/share/ansible/collections
  executable location = /usr/bin/ansible
  python version = 3.10.13 (main, Aug 26 2023, 11:33:35) [GCC 12.2.1 20220924] (/usr/bin/python3)
  jinja version = 3.1.2
  libyaml = False
/ansible # apk update
fetch https://dl-cdn.alpinelinux.org/alpine/v3.17/main/aarch64/APKINDEX.tar.gz

[root@arm-ky10-23-2 opsdeploy]# docker run -it --rm willhallonline/ansible:2.15-alpine-3.14 sh
Unable to find image 'willhallonline/ansible:2.15-alpine-3.14' locally
2.15-alpine-3.14: Pulling from willhallonline/ansible
f7dab3ab2d6e: Already exists 
128b6e8f4dca: Pull complete  #101M
7a255bae75e0: Pull complete 
4f4fb700ef54: Pull complete 
Digest: sha256:fcb16ce3271d36a1bf48835f3a40a487ff03ab1a1e6f891da9232085e8917b62
Status: Downloaded newer image for willhallonline/ansible:2.15-alpine-3.14
standard_init_linux.go:207: exec user process caused "exec format error"

[root@arm-ky10-23-2 opsdeploy]# docker images |grep ansibl
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.14-v2.9.27-mitogen     be6c9c1cd4a5        4 hours ago         336MB
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.8-v2.6.20              550b7d09fa4e        10 hours ago        257MB
willhallonline/ansible                                                        2.15-alpine-3.14               f7d6ff7642cd        3 months ago        548MB #x64 only
willhallonline/ansible                                                        2.9-alpine-3.14                782a333a02e9        3 months ago        239MB #x64 only
willhallonline/ansible                                                        alpine                         ce9803d02db3        3 months ago        465MB #x64, arm64



# [SELF BUILD]
[root@arm-ky10-23-2 opsdeploy]# docker run -it --rm registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.8py3-mitogen-base sh
Unable to find image 'registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.8py3-mitogen-base' locally
alpine3.10-v2.8py3-mitogen-base: Pulling from infrastlabs/env-ansible
26d14edc4f17: Pull complete 
ec6491ba3f60: Pull complete  #97M
2a3cbf1b4a15: Pull complete 
04bb53c83949: Pull complete 
4f4fb700ef54: Pull complete 
Digest: sha256:52cfc1ddfe5a765f3e11a5ad86ca3fdefdd73475403ee6a224a714f5fe12ca72
Status: Downloaded newer image for registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.8py3-mitogen-base
/ansible # 
/ansible # ansible --version
ansible 2.8.8
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.7.10 (default, Mar  2 2021, 09:12:36) [GCC 8.3.0]

[root@arm-ky10-23-2 opsdeploy]# docker run -it --rm registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.9.13py3-mitogen-base sh
Unable to find image 'registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.9.13py3-mitogen-base' locally
alpine3.10-v2.9.13py3-mitogen-base: Pulling from infrastlabs/env-ansible
26d14edc4f17: Already exists 
e524a8b3cf7b: Pull complete 
2cc2bca4fd12: Pull complete 
a026f51a7b68: Pull complete 
4f4fb700ef54: Pull complete 
Digest: sha256:1cc11d4ed9d979e1f579e64a13f3ef45edc3dc1bd2f84be1ced44c5dc7b85c77
Status: Downloaded newer image for registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible:alpine3.10-v2.9.13py3-mitogen-base
/ansible # 
/ansible # ansible --version
ansible 2.9.13
  config file = None
  configured module search path = ['/root/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3.7/site-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.7.10 (default, Mar  2 2021, 09:12:36) [GCC 8.3.0]
/ansible # 

[root@arm-ky10-23-2 opsdeploy]# docker images |grep ansibl
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.10-v2.9.13py3-mitogen-base   8b5f7f71c99f        About a minute ago   271MB ##
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.10-v2.8py3-mitogen-base   5067da01366f        9 minutes ago       243MB ##
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.14-v2.9.27-mitogen        be6c9c1cd4a5        5 hours ago         336MB
registry.cn-shenzhen.aliyuncs.com/infrastlabs/env-ansible                     alpine3.8-v2.6.20                 550b7d09fa4e        11 hours ago        257MB
willhallonline/ansible                                                        2.9-alpine-3.14                   782a333a02e9        3 months ago        239MB ##
```

## arm-jdk

- ansible@alpine; glibc-jdk8(x64正常, arm64不行)

```bash
# arm-jdk8@host23.2:
[root@arm-ky10-23-2 jdk]# ./bin/java -version
java version "1.8.0_202"
Java(TM) SE Runtime Environment (build 1.8.0_202-b08)
Java HotSpot(TM) 64-Bit Server VM (build 25.202-b08, mixed mode)
[root@arm-ky10-23-2 jdk]# pwd
/opt/_sam/opsdeploy/rdeck/jdk

# [root@arm-ky10-23-2 bin]# 
[root@arm-ky10-23-2 bin]# #./java -h
    -javaagent:<jarpath>[=<options>]
                  load Java programming language agent, see java.lang.instrument
    -splash:<imagepath>
                  show splash screen with specified image
See http://www.oracle.com/technetwork/java/javase/documentation/index.html for more details.
[root@arm-ky10-23-2 bin]# ldd ./java
        linux-vdso.so.1 (0x0000fffccad40000)
        libpthread.so.0 => /usr/lib64/libpthread.so.0 (0x0000fffccacd0000)
        libjli.so => /opt/_sam/opsdeploy/rdeck/jdk/bin/./../lib/aarch64/jli/libjli.so (0x0000fffccaca0000)
        libdl.so.2 => /usr/lib64/libdl.so.2 (0x0000fffccac70000)
        libc.so.6 => /usr/lib64/libc.so.6 (0x0000fffccaae0000)
        /lib/ld-linux-aarch64.so.1 (0x0000fffccad50000)

# alpine310-glibc225/227不能识别;
[root@arm-ky10-23-2 bin]# dcp exec rundeck bash
WARNING: The SERVER_IP variable is not set. Defaulting to a blank string.
  # dcp-rundeck:/srv/local/rundeck# which java
  /srv/local/rundeck/rdeck/jdk/bin/java
  # dcp-rundeck:/srv/local/rundeck# java 
  bash: /srv/local/rundeck/rdeck/jdk/bin/java: No such file or directory
  # dcp-rundeck:/srv/local/rundeck# ldd java
  /lib/ld-musl-aarch64.so.1: cannot load java: No such file or directory



##X64#################
dcp-rundeck:/srv/local/rundeck# ldd /srv/local/rundeck/rdeck/jdk/bin/java
        /lib64/ld-linux-x86-64.so.2 (0x7fdce6878000)
        libpthread.so.0 => /lib64/ld-linux-x86-64.so.2 (0x7fdce6878000)
        libjli.so => /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so (0x7fdce6660000)
        libdl.so.2 => /lib64/ld-linux-x86-64.so.2 (0x7fdce6878000)
        libc.so.6 => /lib64/ld-linux-x86-64.so.2 (0x7fdce6878000)
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so: __strdup: symbol not found
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so: __rawmemchr: symbol not found


dcp-rundeck:/srv/local/rundeck# ldd /srv/local/rundeck/rdeck/jdk/bin/javac
        /lib64/ld-linux-x86-64.so.2 (0x7f40d560e000)
        libpthread.so.0 => /lib64/ld-linux-x86-64.so.2 (0x7f40d560e000)
        libjli.so => /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so (0x7f40d53f6000)
        libdl.so.2 => /lib64/ld-linux-x86-64.so.2 (0x7f40d560e000)
        libc.so.6 => /lib64/ld-linux-x86-64.so.2 (0x7f40d560e000)
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so: __strdup: symbol not found
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/amd64/jli/libjli.so: __rawmemchr: symbol not found
```

- arm try2 `multi org-x64's ver try: @aarch64`

```bash
# 2.35; x3
# https://blog.csdn.net/duxing_langzi/article/details/125911398

Executing glibc-bin-2.35-r0.trigger
/usr/glibc-compat/sbin/ldconfig: line 1: syntax error: unexpected "("
ERROR: glibc-bin-2.35-r0.trigger: script exited with error 2
OK: 213 MiB in 107 packages
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# java
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __strdup: symbol not found
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __rawmemchr: symbol not found
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# ps -ef
UID         PID   PPID  C STIME TTY          TIME CMD
root          1      0  0 11:16 ?        00:00:00 /usr/bin/python2 /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
root         47      1  0 11:16 ?        00:00:00 filebrowser --address=0.0.0.0 --port=6661 --noauth --root=/srv/local/rundeck/editor/files --disable-exec --disable-thumbnails
root         48      1  0 11:16 ?        00:00:00 webhookd -listen-addr=:6662
root        105      0  0 11:17 pts/0    00:00:00 bash
root        173      0  0 11:36 pts/1    00:00:00 bash
root        199    173  0 11:42 pts/1    00:00:00 ps -ef
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# which java
/srv/local/rundeck/rdeck/jdk/bin/java
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# java -version
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __strdup: symbol not found
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __rawmemchr: symbol not found
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# pwd
/srv/local/rundeck/rdeck/_glibc


# 
Executing glibc-bin-2.35-r0.trigger
/usr/glibc-compat/sbin/ldconfig: line 1: syntax error: unexpected "("
ERROR: glibc-bin-2.35-r0.trigger: script exited with error 2
OK: 213 MiB in 107 packages
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# java
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __strdup: symbol not found
Error relocating /srv/local/rundeck/rdeck/jdk/bin/../lib/aarch64/jli/libjli.so: __rawmemchr: symbol not found
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# apk del *.apk --allow-untrusted
ERROR: No such package: glibc-2.35-r0.apk
ERROR: No such package: glibc-bin-2.35-r0.apk
ERROR: No such package: glibc-i18n-2.35-r0.apk
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# apk list -I |grep glibc
glibc-bin-2.35-r0 x86_64 {glibc} (LGPL) [installed]
glibc-2.35-r0 x86_64 {glibc} (LGPL) [installed]
glibc-i18n-2.35-r0 noarch {glibc} (LGPL) [installed]
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc# apk del glibc-bin-2.35-r0 glibc-i18n-2.35-r0
ERROR: No such package: glibc-bin-2.35-r0
ERROR: No such package: glibc-i18n-2.35-r0
dcp-rundeck:/srv/local/rundeck/rdeck/_glibc#
```

- try3 `phone.search`>> OK
  - https://blog.csdn.net/qq_38008295/article/details/111467167 华为云鲲鹏服务器测试使用-JDK基础镜像构建 `cyphernode/alpine-glibc-base:arm64-v3.11.0_2.29-0`
  - https://blog.51cto.com/u_16099250/7122742 X86环境拉取arm架构的docker镜像 @
2023-08-17 ``


```bash
# 01: glibc2.31@May 18, 2021; 2.33@Mar 10, 2021; 2.29@May 4, 2019
# https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/
# May 18, 2021
# Alpine 3.12.4 with glibc 2.31-r0 

https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/2.31-r0/glibc-2.31-r0-aarch64.apk
https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/2.31-r0/glibc-bin-2.31-r0-aarch64.apk
https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/2.31-r0/glibc-dev-2.31-r0-aarch64.apk
https://github.com/SatoshiPortal/alpine-pkg-glibc/releases/download/2.31-r0/glibc-i18n-2.31-r0-aarch64.apk


# 02:
# ng: 缺中文字符集
starudream/alpine-glibc        latest          （缺少locale文件及中文字符集）
cyphernode/alpine-glibc-base   v3.12.4_2.31-0  （有locale文件，但缺少中文字符集）
guisea/alpine-glibc            2.33            （Could not open '/lib/ld-linux-aarch64.so.1': No such file or directory）

# ok:
tedli/alpine-glibc:3.14.0
```