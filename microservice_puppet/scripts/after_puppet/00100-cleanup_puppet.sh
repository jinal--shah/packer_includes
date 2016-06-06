#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
# cleanup_puppet.sh
#
if [[ -z "$KEEP_PUPPET" ]]; then
    echo "$0 INFO: ... \$KEEP_PUPPET not defined for this role so will delete packages."
    yum -y erase puppet puppetlabs-release
    rm -rf /etc/puppet 2>/dev/null
    rm -rf /home/ec2-user/eif_puppet* /home/ec2-user/puppet-rsyslog-eif 2>/dev/null
else
    echo "$0 INFO: ... \$KEEP_PUPPET is defined for this role so will not delete packages."
fi

exit 0
