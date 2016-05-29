#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
# 00020-eurostar_domain_info.sh
#
# copy from uploads and clean up
UPLOADS=/tmp/uploads/domain_info

if [[ ! -d $UPLOADS ]]; then
    echo "$0 ERROR: couldn't find uploads dir $UPLOADS"
fi
cp -r  $UPLOADS/* /

rm -rf $UPLOADS
