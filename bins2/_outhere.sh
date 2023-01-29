#!/bin/bash
cur=$(cd "$(dirname "$0")"; pwd)

# docker run --rm -it -v $(pwd):/mnt $img  /mnt/_outhere.sh

tree -h /down/
chmod 777 /down/* ##out-headless-write
cd $cur
    \cp -a /down/* .
    ls -lh; du -sh *