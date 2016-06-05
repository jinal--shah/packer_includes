#!/bin/bash
# vim: et sr sw=4 ts=4 smartindent:
#
# cleanup_puppet.sh
#
yum -y erase puppet puppetlabs-release
rm -rf /etc/puppet 2>/dev/null
rm -rf /home/ec2-user/eif_puppet* /home/ec2-user/puppet-rsyslog-eif 2>/dev/null
