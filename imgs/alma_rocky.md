
cent7.9(无arm)> cent8(停产)> alma/rocky

- RockyLinux/almalinux设置 dnf / yum 国内镜像 https://blog.csdn.net/ximaiyao1984/article/details/126970827

```bash
# 
docker run -it --rm almalinux:8.7-minimal #35.52 MB, 无dnf
[root@903eff1ecd1d /]# rpm
RPM version 4.14.3

node62:~ # docker run -it --rm rockylinux:8.7-minimal
bash-4.4# rpm
RPM version 4.14.3


# 
docker run -it --rm almalinux:8.7 # 68.14 MB, with dnf

```