#!/bin/bash

TARGETPLATFORM=$1
URL=$2

# echo "mkdir -p $TARGETPLATFORM; cd $TARGETPLATFORM"
find
old=$(pwd); mkdir -p $TARGETPLATFORM; cd $TARGETPLATFORM
    curl -O -fSL $URL
    cd $old