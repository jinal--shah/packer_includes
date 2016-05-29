#!/bin/bash

UPLOADS=/tmp/uploads/cloud-init

if [[ ! -d $UPLOADS ]]; then
    echo "$0 INFO: can't find dir $UPLOADS: assuming project has no extra cloud-init scripts uploaded" >&2
    exit 0
fi

find $UPLOADS       \
    -name '*.sh' -o \
    -name '*.py' -o \
    -name '*.rb' -o \
    -name '*.go'    \
    -exec chmod a+x {} \;

cp -r $UPLOADS/* /

rm -rf $UPLOADS

