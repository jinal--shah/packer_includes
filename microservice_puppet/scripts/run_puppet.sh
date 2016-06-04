#!/bin/bash
#
# run_puppet.sh
#
FACTER_operatingsystemmajrelease='6'

MOD_DIRS='
$confdir/environments/$environment/roles
$confdir/environments/$environment/modules
$confdir/environments/common/roles
$confdir/environments/common/modules
$confdir/modules
'
MODULE_PATH=$(echo $MOD_DIRS | sed -e 's/[ \n\r]\+/:/g')

if [[ ! -d "$PUPPET_DIR" ]]; then
    echo "$0 ERROR: puppet dir $PUPPET_DIR is not a directory." >&2
    exit 1
fi

cp -a $PUPPET_DIR /etc/puppet
pushd $PUPPET_DIR                          \
&& puppet apply --parser=future            \
    --verbose --debug --detailed-exitcodes \
    --environment=integration              \
    --hiera_config=/etc/puppet/hiera.yaml  \
    --modulepath="$MODULE_PATH"            \
    -e "hiera_include('classes')"          \
&& popd                                    \
&& rm -rf $PUPPET_DIR

