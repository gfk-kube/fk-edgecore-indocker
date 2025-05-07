

```bash
# bins: ref fk-multi-platform-docker-build//builder/README.md
  tplat.v2505.sh下载二进制包
  imgbuild.sh本地构建

# imgs
  ../edge-kind(bin+conf) >> k8s-kubeedge-iot//k3s,kedge使用;
  multiplat-builder >> fk-multi-platform-docker-build//builder(conf)
  env-system
  env-ansible

# syncer
  src.txt
  export LOCAL_URL="harbor.xxx.com"
  export LOCAL_IP="172.25.20.115"
  export LOCAL_FORMAT='$nslast/$img:$tag' #nsfull/nslast; use '', not ""
  bash syncer/run.sh
```

- samples

```bash
# bin/tplat
host-21-60:/data1/opt/apps/fk-edgecore-indocker # bash bins/tplat.v2505.sh
bins/tplat.v2505.sh: line 18: /data1/opt/apps/fk-edgecore-indocker/bins/down/.list.txt: No such file or directory
destDir: gh.llkk.cc/github.com/cloudflare/cfssl/releases/download/v1.6.5, file: cfssl_1.6.5_linux_amd64
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
 64 11.3M   64 7506k    0     0  89902      0  0:02:12  0:01:25  0:00:47 92957

```

