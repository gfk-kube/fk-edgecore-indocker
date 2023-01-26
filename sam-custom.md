
**Run**

```bash
# --net=host --shm-size 1g -e VNC_OFFSET=99 
docker run -it --rm \
  --tmpfs /run --tmpfs /run/lock --tmpfs /tmp -v /sys/fs/cgroup:/sys/fs/cgroup:rw \
  --cap-add SYS_BOOT --cap-add SYS_ADMIN ctd1
```