
**Run**

```bash
# --net=host --shm-size 1g -e VNC_OFFSET=99 
# --cap-add SYS_BOOT --cap-add SYS_ADMIN
# 
# /_ext/working/_ee/fk-edgecore-indocker/files/usr/local/bin
#  -v $(pwd)/entrypoint:/usr/local/bin/entrypoint
docker run -it --rm --name edgecore \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw --privileged registry.cn-shenzhen.aliyuncs.com/infrastlabs/edgecore

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