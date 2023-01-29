
cent7.9(无arm)> cent8(停产)> alma/rocky

- RockyLinux/almalinux设置 dnf / yum 国内镜像 https://blog.csdn.net/ximaiyao1984/article/details/126970827

```bash
# 
node62:~ # docker run -it --rm rockylinux:8.7-minimal
bash-4.4# rpm
RPM version 4.14.3

# 
docker run -it --rm almalinux:8.7-minimal #35.52 MB, 无dnf
[root@903eff1ecd1d /]# rpm
RPM version 4.14.3
# 
docker run -it --rm almalinux:8.7 # 68.14 MB, with dnf
```

## alma

```bash
# cent7无arm64!!
# replaceRef: https://zhuanlan.zhihu.com/p/591977368
# https://hub.docker.com/_/rockylinux/tags #8.7_arm64_33.75 MB ##10M+
# https://hub.docker.com/_/almalinux/tags #8.7_arm64_34.26 MB ##1M+


# 原文链接：https://blog.csdn.net/ximaiyao1984/article/details/126970827
sed -e 's|^mirrorlist=|#mirrorlist=|g' \
      -e 's|^# baseurl=https://repo.almalinux.org|baseurl=https://mirrors.aliyun.com|g' \
      -i.bak \
      /etc/yum.repos.d/almalinux*.repo

dnf makecache

dnf  -y install iproute net-tools \
  sudo psmisc sysstat tree tmux lrzsz which wget openssl \
  zip unzip

```