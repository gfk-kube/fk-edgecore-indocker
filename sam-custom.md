
**Build**

- imgbuild.sh bins #@23.199 国内env初始 二进制包img
- gitac>> sh buildx.sh #compile<x64,arm64双镜像>

```bash
# v2.2(多版本)
containerd-1.6.15;containerd-fuse-overlayfs-1.0.5;cni-plugins-linux-arm64-v1.2.0;runc_v1.1.4;nerdctl-1.1.0;crictl-v1.26.0;
k3s: v1.22.17;v1.23.15;v1.23.16
kedge: v1.10.3;v1.11.2;v1.12.1;v1.13.0;
# 
cfssl_1.6.3
registry_2.8.1
image-syncer-v1.3.1
go_supervisord_0.7.3
docker-compose_v2.10.2

# v2.3(定版本, +k8s)
k8s: v1.23.17
k3s: v1.23.17-k3s1
kedge: v1.13.0
```

**Run**

```bash
docker pull --platform=arm64 registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:multi-v2
# --net=host --shm-size 1g -e VNC_OFFSET=99 
# --cap-add SYS_BOOT --cap-add SYS_ADMIN
# 
# /_ext/working/_ee/fk-edgecore-indocker/files/usr/local/bin
#  -v $(pwd)/entrypoint:/usr/local/bin/entrypoint
#  cgroup_v2: --cgroupns=host (docker 20.10+)
docker run --platform=arm64 -it --rm --name edgecore \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw --privileged registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore:multi-v2


kc get secret -nkubeedge tokensecret -o=jsonpath='{.data.tokendata}' | base64 -d
tk=..
sed -i -e "s|token: .*|token: ${tk}|g" conf.yml
# headless @ mac23-199 in ~ |02:04:06  
$ docker  exec -it edgecore bash
root@6ef39458218d:/# edgecore --config /edgecore-conf.yml


# 调试containerd-fuse-overlayfs
/usr/local/bin/containerd-fuse-overlayfs-grpc /run/containerd-fuse-overlayfs.sock /var/lib/containerd-fuse-overlayfs
##$ modprobe fuse
modprobe: FATAL: Module fuse not found in directory /lib/modules/5.4.73-1-pve
##改--privileged >> OK
root@5c32e87ce4c1:/# systemctl -a |grep sys-fs
  sys-fs-fuse-connections.mount              loaded    active     mounted   FUSE Control File System 

```

- root@d331bf31808f:/etc# cat /etc/containerd/cri-base.json 

```json
{
  "ociVersion": "1.0.2-dev",
  "process": {
    "user": {
      "uid": 0,
      "gid": 0
    },
    "cwd": "/",
    "capabilities": {
      "bounding": [
        "CAP_CHOWN",
        "CAP_DAC_OVERRIDE",
        "CAP_FSETID",
        "CAP_FOWNER",
        "CAP_MKNOD",
        "CAP_NET_RAW",
        "CAP_SETGID",
        "CAP_SETUID",
        "CAP_SETFCAP",
        "CAP_SETPCAP",
        "CAP_NET_BIND_SERVICE",
        "CAP_SYS_CHROOT",
        "CAP_KILL",
        "CAP_AUDIT_WRITE"
      ],
      "effective": [
        "CAP_CHOWN",
        "CAP_DAC_OVERRIDE",
        "CAP_FSETID",
        "CAP_FOWNER",
        "CAP_MKNOD",
        "CAP_NET_RAW",
        "CAP_SETGID",
        "CAP_SETUID",
        "CAP_SETFCAP",
        "CAP_SETPCAP",
        "CAP_NET_BIND_SERVICE",
        "CAP_SYS_CHROOT",
        "CAP_KILL",
        "CAP_AUDIT_WRITE"
      ],
      "permitted": [
        "CAP_CHOWN",
        "CAP_DAC_OVERRIDE",
        "CAP_FSETID",
        "CAP_FOWNER",
        "CAP_MKNOD",
        "CAP_NET_RAW",
        "CAP_SETGID",
        "CAP_SETUID",
        "CAP_SETFCAP",
        "CAP_SETPCAP",
        "CAP_NET_BIND_SERVICE",
        "CAP_SYS_CHROOT",
        "CAP_KILL",
        "CAP_AUDIT_WRITE"
      ]
    },
    "noNewPrivileges": true
  },
  "root": {
    "path": "rootfs"
  },
  "mounts": [
    {
      "destination": "/proc",
      "type": "proc",
      "source": "proc",
      "options": [
        "nosuid",
        "noexec",
        "nodev"
      ]
    },
    {
      "destination": "/dev",
      "type": "tmpfs",
      "source": "tmpfs",
      "options": [
        "nosuid",
        "strictatime",
        "mode=755",
        "size=65536k"
      ]
    },
    {
      "destination": "/dev/pts",
      "type": "devpts",
      "source": "devpts",
      "options": [
        "nosuid",
        "noexec",
        "newinstance",
        "ptmxmode=0666",
        "mode=0620",
        "gid=5"
      ]
    },
    {
      "destination": "/dev/shm",
      "type": "tmpfs",
      "source": "shm",
      "options": [
        "nosuid",
        "noexec",
        "nodev",
        "mode=1777",
        "size=65536k"
      ]
    },
    {
      "destination": "/dev/mqueue",
      "type": "mqueue",
      "source": "mqueue",
      "options": [
        "nosuid",
        "noexec",
        "nodev"
      ]
    },
    {
      "destination": "/sys",
      "type": "sysfs",
      "source": "sysfs",
      "options": [
        "nosuid",
        "noexec",
        "nodev",
        "ro"
      ]
    },
    {
      "destination": "/run",
      "type": "tmpfs",
      "source": "tmpfs",
      "options": [
        "nosuid",
        "strictatime",
        "mode=755",
        "size=65536k"
      ]
    }
  ],
  "linux": {
    "resources": {
      "devices": [
        {
          "allow": false,
          "access": "rwm"
        }
      ]
    },
    "cgroupsPath": "/default",
    "namespaces": [
      {
        "type": "pid"
      },
      {
        "type": "ipc"
      },
      {
        "type": "uts"
      },
      {
        "type": "mount"
      },
      {
        "type": "network"
      }
    ],
    "maskedPaths": [
      "/proc/acpi",
      "/proc/asound",
      "/proc/kcore",
      "/proc/keys",
      "/proc/latency_stats",
      "/proc/timer_list",
      "/proc/timer_stats",
      "/proc/sched_debug",
      "/sys/firmware",
      "/proc/scsi"
    ],
    "readonlyPaths": [
      "/proc/bus",
      "/proc/fs",
      "/proc/irq",
      "/proc/sys",
      "/proc/sysrq-trigger"
    ]
  },
  "hooks": {
    "createContainer": [
      {
        "path": "/usr/local/bin/mount-product-files"
      }
    ]
  }
}
```