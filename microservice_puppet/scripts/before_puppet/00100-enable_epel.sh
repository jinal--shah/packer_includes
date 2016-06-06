#!/bin/bash
#
# 00100-enable_epel.sh
#
# Uses yum-config-manager to enable epel before puppet run.
#
if [[ -z "$ENABLE_EPEL" ]]; then
    echo "$0 INFO: this role is not configured to enable epel. Exiting."
    exit 0
fi
which yum-config-manager || yum -y install yum-utils # installs yum-config-manager

yum clean headers dbcache
if ! yum repolist all | awk {'print $1'} | grep '^epel$' 2>/dev/null
then
    echo "$0 ERROR: epel not installed. Can't continue." >&2
    exit 1
else
    echo "$0 INFO: ... Found epel. Will enable for puppet run."
fi

yum-config-manager --enable epel
